$LOAD_PATH << 'spec'
$LOAD_PATH << 'lib'

ENV["ENVIRONMENT"] ||= 'rack-development'

require "rubygems"
require "bundler"
require 'active_record'

Bundler.load

require 'haml'
require 'flexi_model'
require 'welltreat_store_framework'

WelltreatStoreFramework::Core.setup do |config|
  config.store_path      = File.join(File.dirname(__FILE__), 'sample')

  # This is for rackup version not required in rails app
  config.database_config = {
      :adapter  => "sqlite3",
      :database => File.join(File.dirname(__FILE__), 'db', 'store.db'),
      :pool     => 5,
      :timeout  => 5000
  }

  # This is for rackup version not required in rails app
  config.database_schema_file = File.join(File.dirname(__FILE__), 'spec', 'fixtures', 'schema.rb')
end

app = WelltreatStoreFramework::Core.find_store_by_name('hello-store')
WelltreatStoreFramework::Core.connect_database!

# Use static file handler
use Rack::Static, :urls => ["/assets"], :root => File.join(app.assets_path, '..')

run app
