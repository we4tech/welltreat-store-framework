require 'spec_helper'

_DEFAULT_STORE_PATH = File.join(File.dirname(__FILE__), '../../../sample')

describe 'SampleApp::HelloStore' do
  before do
    WelltreatStoreFramework::Core.reset!
    WelltreatStoreFramework::Core.setup do |config|
      config.store_path = _DEFAULT_STORE_PATH
    end
  end

  let(:request) { WelltreatStoreFramework::Controller::Request.new }
  let(:response) { WelltreatStoreFramework::Controller::Response.new }
  let(:session) { mock(:session) }

  before(:each) do
    request  = WelltreatStoreFramework::Controller::Request.new
    response = WelltreatStoreFramework::Controller::Response.new
  end

  let(:app) { WelltreatStoreFramework::Core.find_store_by_name('hello-store') }

  before { app.start }

  describe 'controllers' do
    describe '/' do
      it 'should render without error' do
        lambda {
          app.dispatch('/', request, response, {session: session})
        }.should_not raise_error
      end

      describe 'after rendered' do
        before {
          app.models::Product.destroy_all
        }
        let!(:products) {
          5.times.map { |i|
            app.models::Product.create(
                name:        "Product #{i}",
                description: "Prod description #{i}",
                price:       (500 * (i + 1)),
                available:   true
            )
          }
        }

        before { app.dispatch('/', request, response, {session: session}) }
        subject { response }

        its([:products]) { should be }
        its([:title]) { should be }
        its([:products]) { subject.map(&:_id).should == products.map(&:_id) }

        describe 'rendered content' do
          before { app.render!(request, response, {session: session}) }
          subject { response.content }

          it 'should have rendered products' do
            products.each do |product|
              subject.should match product.name
              subject.should match product.description
              subject.should match product.price.to_s
              subject.should match "It's in stock"
            end
          end
        end
      end
    end

    describe '/products/show' do
      before {
        app.models::Product.destroy_all
      }

      let!(:products) {
        5.times.map { |i|
          app.models::Product.create(
              name:        "Product #{i}",
              description: "Prod description #{i}",
              price:       (500 * (i + 1)),
              available:   true
          )
        }
      }

      before { products.first.update_attribute :available, false }

      context 'when valid product id' do
        it 'should render without any problem' do
          lambda {
            app.dispatch("/products/show/#{products.first._id}", request, response, {session: session})
          }.should_not raise_error
        end

        describe 'before rendered' do
          before { app.dispatch("/products/show/#{products.first._id}", request, response, {session: session}) }
          subject { response }

          its([:product]) { should be }

          it 'should render without any error' do
            lambda {
              app.render!(request, response, {session: session})
            }.should_not raise_error
          end

          describe 'after rendered' do
            before { app.render!(request, response, {session: session}) }
            subject { response.content }

            it { should match products.first.name }
            it { should match products.first.description }
            it { should match products.first.price.to_s }
            it { should match "It's outta stock" }
          end
        end
      end
    end

    context 'relationships' do
      describe '/products/reviews/:product_id' do
        it 'should render without any error'
        it 'should assign product variable'
        it 'should assign reviews variable'
      end

      describe '/products/create_reviews/:product_id' do
        it 'should render without any error'
        it 'should create new review'
        it 'should redirect to product page'
      end
    end

  end

  describe 'models'

  describe 'views'
end