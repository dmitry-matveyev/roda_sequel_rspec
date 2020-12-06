ENV["RACK_ENV"] = "test"
require_relative "../app"
require 'rack/test'
require 'pry'

App.plugin :not_found do
  raise "404 - File Not Found"
end

App.plugin :error_handler do |e|
  raise e
end

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.order = :random

  Kernel.srand config.seed

  include Rack::Test::Methods

  def app
    App.freeze.app
  end

  config.around(:each) do |example|
    DB.transaction(rollback: :always, savepoint: true, auto_savepoint: true) { example.run }
  end
end
