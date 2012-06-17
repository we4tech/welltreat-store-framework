require 'spec_helper'

_DEFAULT_STORE_PATH = File.join(File.dirname(__FILE__), '../../../sample')

describe WelltreatStoreFramework::Core do

  describe '.setup' do
    it 'should pass configuration object' do
      subject.class.setup do |config|
        config.should be_instance_of WelltreatStoreFramework::Configuration
      end
    end

    it 'should set store_path' do
      subject.class.setup do |config|
        config.store_path = 'abcdef'
      end

      subject.class.configuration.store_path.should == 'abcdef'
    end
  end

  describe '.find_stores' do
    before do
      WelltreatStoreFramework::Core.setup do |config|
        config.store_path = _DEFAULT_STORE_PATH
      end
    end

    subject { WelltreatStoreFramework::Core.find_stores }

    it { should be_an Hash }
    its('values.first') { should be_a WelltreatStoreFramework::StoreApp }
  end

  describe '.find_store_by_name' do
    context 'when store exists' do
      before do
        WelltreatStoreFramework::Core.setup do |config|
          config.store_path = _DEFAULT_STORE_PATH
        end
      end

      subject { WelltreatStoreFramework::Core.find_store_by_name('hello-store') }

      it { should be_a WelltreatStoreFramework::StoreApp }
    end

    context 'when store does not exist' do
      before do
        WelltreatStoreFramework::Core.reset!
        WelltreatStoreFramework::Core.setup do |config|
          config.store_path = 'invalid-path'
        end
      end

      subject { WelltreatStoreFramework::Core.find_store_by_name('hello-store') }

      it { should be_nil }
    end
  end

  describe WelltreatStoreFramework::StoreApp do
    before do
      WelltreatStoreFramework::Core.reset!
      WelltreatStoreFramework::Core.setup do |config|
        config.store_path = _DEFAULT_STORE_PATH
      end
    end

    let(:app) { WelltreatStoreFramework::Core.find_store_by_name('hello-store') }
    subject { app }

    # Attributes
    [:name, :controllers_path, :models_path, :config_path, :assets_path, :path].each do |_attr|
      its(_attr) { should be }
    end

    its(:name) { should == 'hello-store' }
    its(:config_path) { should == File.join(_DEFAULT_STORE_PATH, 'hello-store', 'config') }
    its(:controllers_path) { should == File.join(_DEFAULT_STORE_PATH, 'hello-store', 'controllers') }
    its(:models_path) { should == File.join(_DEFAULT_STORE_PATH, 'hello-store', 'models') }
    its(:views_path) { should == File.join(_DEFAULT_STORE_PATH, 'hello-store', 'views') }

    # Methods
    [:start, :stop, :restart].each do |_method|
      it "should have `#{_method}`" do
        subject.respond_to?(_method).should be
      end
    end

    describe '#start' do
      before do
        WelltreatStoreFramework::Core.reset!
        WelltreatStoreFramework::Core.setup do |config|
          config.store_path = _DEFAULT_STORE_PATH
        end
      end

      let(:app) { WelltreatStoreFramework::Core.find_store_by_name('hello-store') }
      subject { app }

      its(:start) { should be }

      describe 'initiated module' do
        subject { app.send(:_base_module) }

        it { should be_a Module }
        its(:name) { should match /^WelltreatStoreFramework::StoreApp::HelloStore\d*/ }

        [:Controllers, :Models].each do |_const|
          it "should have defined constant #{_const}" do
            subject.const_defined?(_const).should be
          end
        end

        describe ':Controllers' do
          subject { app.send(:_base_module)::Controllers }

          it 'should have defined Products' do
            subject.const_defined?(:Products).should be
          end

          it 'should define products as class' do
            subject::Products.should be_a Class
          end
        end

        describe ':Models' do
          subject { app.send(:_base_module)::Models }

          it 'should have defined models' do
            subject.const_defined?(:Product).should be
          end
        end
      end
    end

    describe '#stop' do
      before do
        WelltreatStoreFramework::Core.reset!
        WelltreatStoreFramework::Core.setup do |config|
          config.store_path = _DEFAULT_STORE_PATH
        end
      end

      let(:app) { WelltreatStoreFramework::Core.find_store_by_name('hello-store') }
      before { app.start }

      context 'before stop' do
        it 'should have module' do
          app.instance_variable_get(:@_base_module).should be
          app.send(:_base_module).should be_a Module
          app.send(:_base_module)::Controllers.should be_a Module
          app.send(:_base_module)::Models.should be_a Module
        end
      end

      context 'after stop' do
        before { app.stop }

        it 'should dispose module' do
          app.instance_variable_get(:@_base_module).should be_nil
        end

        it 'should return true on successful stop' do
          app.start
          app.stop.should be
        end
      end
    end
  end

end