require_relative 'spec_helper'

RSpec.describe CustomerRepository do
  before :each do
    @mock_engine = double('CustomerRepository')
    @path = "fixture/customer_fixture.csv"
    @customer_repo = CustomerRepository.new(@path, @mock_engine)
  end

  describe 'instantiation' do
    it 'exists' do
      expect(@customer_repo).to be_a(CustomerRepository)
    end

    it 'returns an array of all known customers with readable attributes' do
      expect(@customer_repo.all).to be_an(Array)
      expect(@customer_repo.all.length).to eq(10)
      expect(@customer_repo.all.first.id).to eq(1)
      expect(@customer_repo.all.first.first_name).to eq("Joey")
      expect(@customer_repo.all.first.last_name).to eq("Ondricka")
      expect(@customer_repo.all.first.created_at).to be_a(Time)
      expect(@customer_repo.all.first.updated_at).to be_a(Time)
    end
  end

  describe 'methods' do
    it 'can find customers given a unique id' do
      expect(@customer_repo.find_by_id(2)).to eq(@customer_repo.all[1])
    end

    it 'can find customers given a first name' do
      first_name = "Ramona"
      expect(@customer_repo.find_all_by_first_name(first_name)).to be_an(Array)
      expect(@customer_repo.find_all_by_first_name(first_name).length).to eq(1)
      first_name = "Mista Bombastic"
      expect(@customer_repo.find_all_by_first_name(first_name)).to eq([])
    end

    it 'can find customers given a last name' do
      last_name = "Toy"
      expect(@customer_repo.find_all_by_last_name(last_name)).to be_an(Array)
      expect(@customer_repo.find_all_by_last_name(last_name).length).to eq(1)
      last_name = "Incravina"
      expect(@customer_repo.find_all_by_last_name(last_name)).to eq([])
    end

    it 'can create a new customer' do
      attributes = @customer_data = {
                                      :id => 13,
                                      :first_name => "Natalie",
                                      :last_name => "Imbruglia",
                                      :created_at => Time.now,
                                      :updated_at => Time.now
                                    }
      @customer_repo.create(attributes)
      expect(@customer_repo.all.length).to eq(11)
      expect(@customer_repo.all.last.id).to eq(11)
      expect(@customer_repo.all.last.first_name).to eq("Natalie")
    end
  end
end
