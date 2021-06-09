require_relative 'spec_helper'

RSpec.describe TransactionRepository do
  before :each do
    @mock_engine = double('TransactionRepository')
    @path = "fixture/transaction_fixture.csv"
    @transaction_repo = TransactionRepository.new(@path, @mock_engine)
  end

  describe 'instantiation' do
    it 'exists' do
      expect(@transaction_repo).to be_a(TransactionRepository)
    end

    it 'returns an array of all known transactions with readable attributes' do
      expect(@transaction_repo.all).to be_an(Array)
      expect(@transaction_repo.all.length).to eq(10)
      expect(@transaction_repo.all.first.id).to eq(1)
      expect(@transaction_repo.all.first.invoice_id).to eq(2179)
      expect(@transaction_repo.all.first.credit_card_number).to eq("4068631943231473")
      expect(@transaction_repo.all.first.credit_card_expiration_date).to eq("0217")
      expect(@transaction_repo.all.first.result).to eq(:success)
      expect(@transaction_repo.all.first.created_at).to be_a(Time)
      expect(@transaction_repo.all.first.updated_at).to be_a(Time)
    end
  end

  describe 'methods' do
    it 'can find transactions given a unique id' do
      expect(@transaction_repo.find_by_id(9)).to eq(@transaction_repo.all[8])
    end

    it 'can find transactions given a unique invoice id' do
      id = 290
      expect(@transaction_repo.find_all_by_invoice_id(id)).to be_an(Array)
      expect(@transaction_repo.find_all_by_invoice_id(id).length).to eq(1)
      id = 8448
      expect(@transaction_repo.find_all_by_invoice_id(id)).to eq([])
    end

    it 'can find transactions given a credit card number' do
      number = "4068631943231473"
      expect(@transaction_repo.find_all_by_credit_card_number(number)).to be_an(Array)
      expect(@transaction_repo.find_all_by_credit_card_number(number).length).to eq(1)
      number = "6179420851156782"
      expect(@transaction_repo.find_all_by_credit_card_number(number)).to eq([])
    end

    it 'can find transactions given a result' do
      result = :success
      expect(@transaction_repo.find_all_by_result(result)).to be_an(Array)
      expect(@transaction_repo.find_all_by_result(result).length).to eq(9)

      result = :cows
      expect(@transaction_repo.find_all_by_result(result)).to eq([])
    end

    it 'can create a new transaction' do
      attributes = {
        id: 11,
        invoice_id: 71,
        credit_card_number: "1111222233334444",
        credit_card_expiration_date: "6969",
        result: :success,
        created_at: Time.now,
        updated_at: Time.now
      }

      @transaction_repo.create(attributes)
      expect(@transaction_repo.all.length).to eq(11)
      expect(@transaction_repo.all.last.id).to eq(11)
      expect(@transaction_repo.all.last.credit_card_number).to eq("1111222233334444")
    end

    it 'can update id and attributes' do
      id = 10
      attributes = {
                    credit_card_number: "55556666677778888",
                    credit_card_expiration_date: "0720",
                    result: :success
                    }

      @transaction_repo.update(10, attributes)
      expect(@transaction_repo.all[9].credit_card_number).to eq("55556666677778888")
      expect(@transaction_repo.all[9].credit_card_expiration_date).to eq("0720")
      expect(@transaction_repo.all[9].updated_at).to be_a(Time)
    end

    it 'deletes transactions' do
      expect(@transaction_repo.all.length).to eq(10)
      id = 1
      @transaction_repo.delete(id)
      expect(@transaction_repo.all.length).to eq(9)
    end
  end
end
