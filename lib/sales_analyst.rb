require_relative './sales_engine'
require_relative '../module/incravinable'


class SalesAnalyst
  include Incravinable

  attr_reader :sales_engine

  def initialize(sales_engine)
    @sales_engine = sales_engine
  end

  def average_items_per_merchant
    sales_engine.all_items.length.fdiv(sales_engine.all_merchants.length).round(2)
  end

  def number_items_per_merchant
    item_merchant_hash = {}
    sales_engine.all_merchants.each do |merchant|
      item_merchant_hash[merchant] = sales_engine.items.find_all_by_merchant_id(merchant.id).length
    end
    item_merchant_hash
  end

  def avg(data)
    data.sum.fdiv(data.length)
  end

  def std_dev(data)
    numerator = data.reduce(0) do |sum, num|
      sum + (num - avg(data))**2
    end
    Math.sqrt(numerator/(data.length - 1)).round(2)
  end

  def average_items_per_merchant_standard_deviation
    std_dev(self.number_items_per_merchant.values).round(2)
  end

  def merchants_with_high_item_count
    top_merchants = []
    sigma = (average_items_per_merchant_standard_deviation + average_items_per_merchant)
    number_items_per_merchant.find_all do |merchant, quantity|
      if quantity > sigma
        top_merchants << merchant
      end
    end
    top_merchants
  end

  def average_item_price_for_merchant(merchant_id)
    items = sales_engine.all_items
    merchant_items = sales_engine.find_all_with_merchant_id(merchant_id, items)
    sum = merchant_items.sum do |item|
      item.unit_price
    end
    (sum / merchant_items.length).round(2)
  end

  def average_average_price_per_merchant
    average_array = []
    sales_engine.all_merchants.each do |merchant|
    average_array << average_item_price_for_merchant(merchant.id)
    end
    (average_array.sum / average_array.length).round(2)
  end

  def golden_items
    price_array = []
    sales_engine.all_items.each do |item|
     price_array << item.unit_price
    end
    std_dev_prices = std_dev(price_array)
    sigma2 = ((std_dev_prices * 2) + average_average_price_per_merchant)
    top_items = []
    sales_engine.all_items.each do |item|
      top_items << item if item.unit_price > sigma2
    end
    top_items
  end

  def average_invoices_per_merchant
    sales_engine.all_invoices.length.fdiv(sales_engine.all_merchants.length).round(2)
  end

  def number_invoices_per_merchant
    invoices_merchant_hash = {}
    sales_engine.all_merchants.each do |merchant|
      invoices_merchant_hash[merchant] = sales_engine.invoices.find_all_by_merchant_id(merchant.id).length
    end
    invoices_merchant_hash
  end

  def average_invoices_per_merchant_standard_deviation
    std_dev(self.number_invoices_per_merchant.values).round(2)
  end

  def top_merchants_by_invoice_count
    top_merchants = []
    sigma2 = ((average_invoices_per_merchant_standard_deviation * 2) + average_invoices_per_merchant)
    number_invoices_per_merchant.find_all do |merchant, quantity|
      top_merchants << merchant if quantity > sigma2
    end
    top_merchants
  end

  def bottom_merchants_by_invoice_count
    bottom_merchants = []
    sigma2 = (average_invoices_per_merchant - (average_invoices_per_merchant_standard_deviation * 2))
    number_invoices_per_merchant.find_all do |merchant, quantity|
      bottom_merchants << merchant if quantity < sigma2
    end
    bottom_merchants
  end

  def date_invoice_hash
    date_with_invoices_hash = Hash.new { |hash, key| hash[key] = Array.new }
    sales_engine.all_invoices.each do |invoice|
      date_with_invoices_hash[invoice.created_at] << invoice
    end
    date_with_invoices_hash
  end

  def average_invoices_per_day
    num_invoices_per_day = self.date_invoice_hash.values.map do |value|
      value.length
    end
    avg(num_invoices_per_day).round(2)
  end

  def invoices_per_day_standard_deviation
    num_invoices_per_day = self.date_invoice_hash.values.map do |value|
      value.length
    end
    std_dev(num_invoices_per_day).round(2)
  end

  def top_days_by_invoice_count
    sigma = (self.average_invoices_per_day + self.invoices_per_day_standard_deviation)
    top_days = []
    self.date_invoice_hash.each do |key, value|
      top_days << key.strftime('%A') if value.length > sigma
    end
    top_invoice_day = []
    top_invoice_day << top_days.max
    top_invoice_day
  end

  def invoice_status(status)
    invoices_with_status = []
    sales_engine.all_invoices.each do |invoice|
      if invoice.status == status
        invoices_with_status << invoice
      end
    end
    percentage = (invoices_with_status.length.to_f / sales_engine.all_invoices.length) * 100
    percentage.round(2)
  end

  def invoice_paid_in_full?(invoice_id)
    @sales_engine.transactions.find_all_by_invoice_id(invoice_id).any? do |transaction|
      transaction.result == :success
    end
  end

  def invoice_total(invoice_id)
    array = []
    @sales_engine.all_invoice_items.each do |invoice_item|
     if invoice_item.invoice_id == invoice_id
       array << invoice_item.quantity * invoice_item.unit_price
     end
   end
   array.sum
  end

  def total_revenue_by_date(date)
    invoices = @sales_engine.all_invoices.find_all do |invoice|
      invoice.created_at.strftime('%Y-%m-%d') == date.strftime('%Y-%m-%d')
    end
    invoice_ids = invoices.map do |invoice|
      invoice.id
    end
    invoice_ids.sum do |id|
      invoice_total(id)
    end
  end

  # def top_revenue_earners(num = 20)
  #   @sales_engine.all_invoices.map do |invoice|
  #
  #   # @sales_engine.all_merchants.sort_by
  # end

  def merchants_with_pending_invoices
    not_paid = @sales_engine.all_invoices.find_all do |invoice|
      invoice_paid_in_full?(invoice.id) != true
    end
    merch_ids = not_paid.map do |invoice|
      invoice.merchant_id
    end
    merch_ids.map do |id|
      @sales_engine.merchants.find_by_id(id)
    end.uniq
  end

  def merchants_with_only_one_item
    merchants = []
    number_items_per_merchant.each do |merchant, items|
      if items == 1
        merchants << merchant
      end
    end
    merchants
  end

  def items_created_per_merchant(month)
    hash = Hash.new { |hash, key| hash[key] = Array.new }
    @sales_engine.all_items.each do |item|
      if item.created_at.strftime('%B') == month
        hash[item.merchant_id] = item
      end
    end
    hash
  end
  
  def merchants_with_only_one_item_registered_in_month(month)
    items_created_per_merchant(month)
  end
end
