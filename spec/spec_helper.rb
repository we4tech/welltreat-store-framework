ENV["ENVIRONMENT"] ||= 'test'

require "rubygems"
require "bundler"
require 'active_record'

Bundler.load

require 'rspec/autorun'
Dir.glob(File.join('spec', 'factories', '*')).each { |f| require f }

require 'spec_helper/active_record'
require 'spec_helper/rspec'
require 'spec_helper/models'

require 'haml'
require 'flexi_model'
require 'welltreat_store_framework'

