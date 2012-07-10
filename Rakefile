require 'rubygems'
require 'bundler'
require 'rake'
require 'rake/testtask'
require 'rspec/core/rake_task'

task :default => 'spec:unit' do
end

namespace :spec do
  desc "Run acceptance specs"
  RSpec::Core::RakeTask.new('unit') do |t|
    t.pattern = 'spec/lib/**/*_spec.rb'
  end
end

begin
  require "jeweler"
  Jeweler::Tasks.new do |gem|
    gem.name    = "welltreat-store-framework"
    gem.summary = "Build store just like your another web development project."
    gem.homepage = 'https://github.com/we4tech/welltreat-store-framework/'
    gem.description = 'WellTreat Store Framework'
    gem.email   = ["hasan83bd@gmail.com"]
    gem.authors = ["nhm tanveer hossain khan"]
    gem.files   = Dir["{lib}/**/*", "{spec}/**/*", "{sample}/**/*"]
  end

  Jeweler::GemcutterTasks.new
rescue
  puts "Jeweler or dependency not available."
end
