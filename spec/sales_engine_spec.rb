require_relative 'spec_helper'

RSpec.describe SalesEngine do
  before :each do
    @paths = {
      :items     => 'fixture/item_fixture.csv',
      :merchants => 'fixture/merchant_fixture.csv',
      :invoices  => 'fixture/invoice_fixture.csv',
      :invoice_items => 'fixture/invoice_item_fixture.csv',
      :transactions => 'fixture/transaction_fixture.csv',
      :customers => 'fixture/customer_fixture.csv'
    }
    @engine = SalesEngine.new(@paths)
  end

  describe 'instantiation' do

    it 'exists' do
      expect(@engine).to be_a(SalesEngine)
    end
  end

  describe 'Access to repositories' do
    it 'has access to MerchantRepository' do
      expect(@engine.merchants).to be_a(MerchantRepository)
      expect(@engine.all_merchants).to be_an(Array)
    end

    it 'has access to ItemRepository' do
      expect(@engine.items).to be_a(ItemRepository)
      expect(@engine.all_items).to be_an(Array)
    end
    it 'has access to InvoiceRepository' do
      expect(@engine.invoices).to be_a(InvoiceRepository)
      expect(@engine.all_invoices).to be_an(Array)
    end
    it 'has access to InvoiceItemRepository' do
      expect(@engine.invoice_items).to be_a(InvoiceItemRepository)
      expect(@engine.all_invoice_items).to be_an(Array)
    end
    it 'has access to TransactionRepository' do
      expect(@engine.transactions).to be_a(TransactionRepository)
      expect(@engine.all_transactions).to be_an(Array)
    end
    it 'has access to CustomerRepository' do
      expect(@engine.customers).to be_a(CustomerRepository)
      expect(@engine.all_customers).to be_an(Array)
    end
  end
end
