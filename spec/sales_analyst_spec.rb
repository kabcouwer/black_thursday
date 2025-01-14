require_relative 'spec_helper'

RSpec.describe 'SalesAnalyst' do
  before :each do
    @sales_engine = SalesEngine.from_csv({
                                          :items => "./data/items.csv",
                                          :merchants => "./data/merchants.csv",
                                          :invoices => "./data/invoices.csv",
                                          :invoice_items => "./data/invoice_items.csv",
                                          :transactions => "./data/transactions.csv",
                                          :customers => "./data/customers.csv"
                                        })

    @sales_analyst = @sales_engine.analyst
  end
  describe 'instantiation' do
    it 'exists' do
      expect(@sales_analyst).to be_a(SalesAnalyst)
    end

    it 'has access to Sales Engine' do
      expect(@sales_engine.items).to be_a(ItemRepository)
      expect(@sales_engine.all_items).to be_an(Array)
      expect(@sales_engine.merchants).to be_a(MerchantRepository)
      expect(@sales_engine.all_merchants).to be_an(Array)
      expect(@sales_engine.invoices).to be_a(InvoiceRepository)
      expect(@sales_engine.all_invoices).to be_an(Array)
      expect(@sales_engine.invoice_items).to be_an(InvoiceItemRepository)
      expect(@sales_engine.all_invoice_items).to be_an(Array)
      expect(@sales_engine.transactions).to be_an(TransactionRepository)
      expect(@sales_engine.all_transactions).to be_an(Array)
      expect(@sales_engine.customers).to be_a(CustomerRepository)
      expect(@sales_engine.all_customers).to be_an(Array)
    end
  end

  describe 'methods' do
    it 'can return the average items per merchant' do
      expect(@sales_analyst.average_items_per_merchant).to eq(2.88)
    end

    it 'can return number of items per merchant' do
      expect(@sales_analyst.number_items_per_merchant).to be_an(Hash)
      expect(@sales_analyst.number_items_per_merchant.keys.first).to be_an(Merchant)
      expect(@sales_analyst.number_items_per_merchant.values.first).to be_an(Integer)
    end

    it 'can return an average of an array with integers' do
      data = [1, 5, 9]

      expect(@sales_analyst.avg(data)).to eq(5)
    end

    it 'can return the standard deviation of an array of itegers' do
      data = [21, 4224, 17, 8008]

      expect(@sales_analyst.std_dev(data)).to eq(3844.16)
    end

    it 'can return the average items per mechant standard dev' do
      expect(@sales_analyst.average_items_per_merchant_standard_deviation).to eq(3.26)
    end

    it 'can return the merchants that have the most items for sale' do
      expect(@sales_analyst.merchants_with_high_item_count).to be_an(Array)
      expect(@sales_analyst.merchants_with_high_item_count.count).to eq(52)
    end

    it 'can find the average price of a merchants items' do
      merchant_id = 12334159

      expect(@sales_analyst.average_item_price_for_merchant(merchant_id)).to be_a(BigDecimal)
    end

    it 'can sum all the averages and find the average price across all merchants' do
      expect(@sales_analyst.average_average_price_per_merchant).to be_a(BigDecimal)
    end

    it 'can find items that are two deviations above the average price' do
      expect(@sales_analyst.golden_items).to be_an(Array)
      expect(@sales_analyst.golden_items.first).to be_an(Item)
      expect(@sales_analyst.golden_items.length).to eq(5)
    end

    it 'can return number of invoices the average merchant has' do
      expect(@sales_analyst.average_invoices_per_merchant).to eq(10.49)
    end

    it 'can return standard deviation of average invoices per merchant' do
      expect(@sales_analyst.average_invoices_per_merchant_standard_deviation). to eq(3.29)
    end

    it 'can return merchants that are more than 2 standard deviations above the mean' do
      expect(@sales_analyst.top_merchants_by_invoice_count).to be_an(Array)
      expect(@sales_analyst.top_merchants_by_invoice_count.first).to be_a(Merchant)
      expect(@sales_analyst.top_merchants_by_invoice_count.count).to eq(12)
    end

    it 'can find the merchants more than 2 standard deviations below the mean' do
      expect(@sales_analyst.bottom_merchants_by_invoice_count).to be_an(Array)
      expect(@sales_analyst.bottom_merchants_by_invoice_count.first).to be_a(Merchant)
    end

    it 'can create a hash where the keys are dates and the values are invoices sold on that date' do
      expect(@sales_analyst.date_invoice_hash).to be_a(Hash)
      expect(@sales_analyst.date_invoice_hash.keys.first).to be_a(Time)
      expect(@sales_analyst.date_invoice_hash.values).to be_an(Array)
    end

    it 'can find the average invoices per day' do
      expect(@sales_analyst.average_invoices_per_day).to eq(1.48)
    end

    it 'can find the standard deviation of invoices per day' do
      expect(@sales_analyst.invoices_per_day_standard_deviation).to be_an(Float)
      expect(@sales_analyst.invoices_per_day_standard_deviation).to eq(0.74)
    end

    it 'can find the top days by invoice count' do
      expect(@sales_analyst.top_days_by_invoice_count.length).to eq(1)
      expect(@sales_analyst.top_days_by_invoice_count.first).to eq("Wednesday")
    end

    it 'can return the percentage of invoices that are not shipped' do
      expect(@sales_analyst.invoice_status(:pending)).to eq(29.55)
      expect(@sales_analyst.invoice_status(:shipped)).to eq(56.95)
      expect(@sales_analyst.invoice_status(:returned)).to eq(13.5)
    end

    it 'can return true if the invoice with the corresponding id is paid in full' do
      invoice_id = 2179
      expect(@sales_analyst.invoice_paid_in_full?(invoice_id)).to eq(true)
      invoice_id = 17522
      expect(@sales_analyst.invoice_paid_in_full?(invoice_id)).to eq(false)
    end

    it 'can return the total $ amount of the invoice with corresponding id' do
      invoice_id = 3560
      expect(@sales_analyst.invoice_total(invoice_id)).to eq(0.3116147e5)
    end

    it 'can find the total revenue for a given date' do
      date = Time.parse('2001-11-24')
      expect(@sales_analyst.total_revenue_by_date(date)).to eq(0.256022e4)
    end

    it 'can find desired number of top revenue earners' do
      expect(@sales_analyst.top_revenue_earners(10)).to be_an(Array)
      expect(@sales_analyst.top_revenue_earners.first.class).to be_a(Merchant)
      expect(@sales_analyst.top_revenue_earners.first.id).to eq(12335747)
    end

    it 'can find all merchants with pending invoices' do
      expect(@sales_analyst.merchants_with_pending_invoices).to be_an(Array)
      expect(@sales_analyst.merchants_with_pending_invoices.first).to be_a(Merchant)
    end

    it 'can return a list of merchants with only one item' do
      expect(@sales_analyst.merchants_with_only_one_item.length).to eq(243)
      expect(@sales_analyst.merchants_with_only_one_item).to be_an(Array)
      expect(@sales_analyst.merchants_with_only_one_item.first).to be_a(Merchant)
    end

    it 'can return a list of merchants with only one item registered in a given month' do
      expect(@sales_analyst.merchants_with_only_one_item_registered_in_month).to be_an(Array)
      expect(@sales_analyst.merchants_with_only_one_item_registered_in_month.first).to be_a(Merchant)
    end

    it 'can create a hash with items per merchant' do
      month = 'March'
      expect(@sales_analyst.items_created_per_merchant(month)).to be_a(Hash)
      expect(@sales_analyst.items_created_per_merchant(month).length).to eq(21)
    end
  end
end
