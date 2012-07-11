require 'spec_helper'

_DEFAULT_STORE_PATH = File.join(File.dirname(__FILE__), '../../../sample')

describe WelltreatStoreFramework::StoreApp do
  before do
    WelltreatStoreFramework::Core.reset!
    WelltreatStoreFramework::Core.setup do |config|
      config.store_path  = _DEFAULT_STORE_PATH
      config.auto_reload = true
    end
  end

  let(:app) { WelltreatStoreFramework::Core.find_store_by_name('hello-store') }
  before { app.start }

  describe '#dispatch' do
    let(:request) { WelltreatStoreFramework::Controller::Request.new }
    let(:response) { WelltreatStoreFramework::Controller::Response.new }
    let(:session) { mock(:session) }

    it 'should not throw any exception' do
      lambda {
        app.dispatch('/', request, response, {session: session})
      }.should_not raise_error
    end

    describe 'response object' do
      before { app.dispatch('/', request, response, {session: session}) }
      subject { response }

      its(:template) { should == :index }
      its(:layout) { should == :default }
      its(:values) { subject[:title].should == 'Hello World' }
      its(:values) { subject[:name].should == 'Hasan' }
      its(:status) { should == 200 }
    end

    describe 'rendered content' do
      before { app.dispatch('/', request, response, {session: session}) }
      before { app.render!(request, response, {session: session}) }
      subject { response }

      its(:content) { should match 'Hasan' }
      its(:content) { should match 'Hello World' }
    end

    describe 'product controller' do
      before { app.dispatch('/products', request, response, {session: session}) }
      before { app.render!(request, response, {session: session}) }
      subject { response }

      its(:template) { should == :index }
      its(:layout) { should == :default }
      its(:content) { should match "Product 1" }
      its(:content) { should match "Product 2" }
      its(:content) { should match "<!DOCTYPE html>" }
    end

    context 'auto reload enabled' do
      it 'should have same base module name' do
        _old_app_mod = app.send(:_base_module).name
        app.dispatch('/', request, response, {session: session})

        app.send(:_base_module).name.should eql _old_app_mod
      end

      it 'should have different base object_id' do
        _old_app_mod_id = app.send(:_base_module).object_id
        app.dispatch('/', request, response, {session: session})

        app.send(:_base_module).object_id.should_not eql _old_app_mod_id
      end

    end

    context 'not found url' do
      before { app.dispatch('/Something does not exists', request, response, {session: session}) }
      before { app.render!(request, response, {session: session}) }
      subject { response }

      its(:content) { should match /not\s*found/i }
    end
  end

end