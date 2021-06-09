class Customer
  attr_reader :id,
              :first_name,
              :last_name,
              :created_at,
              :updated_at,
              :repo

  def initialize(customer_data, repo)
    @id = customer_data[:id].to_i
    @first_name = customer_data[:first_name]
    @last_name = customer_data[:last_name]
    @created_at = customer_data[:created_at]
    @updated_at = customer_data[:updated_at]
    @repo = repo
  end

  def new_id(id_number)
    @id = id_number
  end
end
