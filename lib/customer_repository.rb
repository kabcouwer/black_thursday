require_relative '../module/incravinable'

class CustomerRepository

  include Incravinable

  def inspect
    "#<#{self.class} #{@customers.size} rows>"
  end

  attr_reader :all,
              :engine

  def initialize(path, engine)
    @all = []
    create_customers(path)
    @engine = engine
  end

  def create_customers(path)
    customers = CSV.foreach(path, headers: true, header_converters: :symbol) do |customer_data|
      customer_hash = {
                        id: customer_data[:id],
                        first_name: customer_data[:first_name],
                        last_name: customer_data[:last_name],
                        created_at: Time.parse(customer_data[:created_at]),
                        updated_at: Time.parse(customer_data[:updated_at])
                      }

      @all << Customer.new(customer_hash, self)
    end
  end

  def find_by_id(id)
    find_with_id(id, @all)
  end

  def find_all_by_first_name(first_name)
    @all.find_all do |customer|
      customer.first_name == first_name
    end
  end

  def find_all_by_last_name(last_name)
    @all.find_all do |customer|
      customer.last_name == last_name
    end
  end

  def create(attributes)
    highest_id = @all.max_by do |customer|
      customer.id
    end
    new_customer = Customer.new(attributes, self)
    new_customer.new_id(highest_id.id + 1)
    @all << new_customer
  end

  def update(id, attributes)
    found_customer = find_by_id(id)
    if found_customer != nil
      found_customer.update_first_name(attributes[:first_name]) unless attributes[:first_name].nil?
      found_customer.update_last_name(attributes[:last_name]) unless attributes[:last_name].nil?
      found_customer.update_time
    end
  end
end
