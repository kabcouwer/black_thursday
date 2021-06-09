require 'rspec'
require 'simplecov'

SimpleCov.start
SimpleCov.add_filter ["spec"]

require 'bigdecimal'
require 'CSV'

require_relative '../lib/sales_engine'
require_relative '../lib/item'
require_relative '../lib/item_repository'
require_relative '../lib/merchant'
require_relative '../lib/merchant_repository'
require_relative '../lib/invoice'
require_relative '../lib/invoice_repository'
require_relative '../lib/sales_analyst'
require_relative '../lib/invoice_item'
require_relative '../lib/invoice_item_repository'
require_relative '../lib/transaction'
require_relative '../lib/transaction_repository'

