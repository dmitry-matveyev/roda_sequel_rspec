require_relative 'models'

require 'roda'

class App < Roda
  opts[:check_dynamic_arity] = false
  opts[:check_arity] = :warn

  plugin :default_headers,
    'Content-Type'=>'text/html',
    #'Strict-Transport-Security'=>'max-age=16070400;', # Uncomment if only allowing https:// access
    'X-Frame-Options'=>'deny',
    'X-Content-Type-Options'=>'nosniff',
    'X-XSS-Protection'=>'1; mode=block'

  plugin :hash_routes

  logger = if ENV['RACK_ENV'] == 'test'
    Class.new{def write(_) end}.new
  else
    $stderr
  end
  plugin :common_logger, logger

  plugin :not_found do
    'Not Found'
  end

  if ENV['RACK_ENV'] == 'development'
    plugin :exception_page
  end

  plugin :error_handler do |e|
    $stderr.print "#{e.class}: #{e.message}\n"
    $stderr.puts e.backtrace
    next exception_page(e) if ENV['RACK_ENV'] == 'development'
 
    'Server Error'
  end

  plugin :json

  Unreloader.require('routes'){}

# TODO: fix me
# hash_routes '/api' do
#   get 'records' do
#     Record.all
#   end
# end

# r.hash_routes

  route do |r|
    r.on 'api' do
      r.get 'records' do
        Record.all.map(&:values)
      end
    end
  end
end
