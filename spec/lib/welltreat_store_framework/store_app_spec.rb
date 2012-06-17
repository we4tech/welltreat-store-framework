require 'spec_helper'

_DEFAULT_STORE_PATH = File.join(File.dirname(__FILE__), '../../../sample')

describe WelltreatStoreFramework::StoreApp do
  before do
    WelltreatStoreFramework::Core.reset!
    WelltreatStoreFramework::Core.setup do |config|
      config.store_path = _DEFAULT_STORE_PATH
    end
  end

  let(:app) { WelltreatStoreFramework::Core.find_store_by_name('hello-store') }
  before { app.start }

  describe '#dispatch' do
    let(:request) { WelltreatStoreFramework::Controller::Request.new }
    let(:response) { WelltreatStoreFramework::Controller::Response.new }

    it 'should not throw any exception' do
      lambda {
        app.dispatch('/', request, response)
      }.should_not raise_error
    end

    describe 'response object' do
      before { app.dispatch('/', request, response) }
      subject { response }

      its(:template) { should == :index }
      its(:layout) { should == :default }
      its(:values) { subject[:title].should == 'Hello World' }
      its(:values) { subject[:name].should == 'Hasan' }
      its(:status) { should == 200 }
    end

    describe 'rendered content' do
      before { app.dispatch('/', request, response) }
      before { app.render!(request, response) }
      subject { response }

      its(:content) { should match 'Hasan' }
      its(:content) { should match 'Hello World' }
    end

    describe 'product controller' do
      before { app.dispatch('/products', request, response) }
      before { app.render!(request, response) }
      subject { response }

      its(:template) { should == :index }
      its(:layout) { should == :default }
      its(:content) { should match "Product 1"}
      its(:content) { should match "Product 2"}
      its(:content) { should match "<!DOCTYPE html>"}
    end
  end

end