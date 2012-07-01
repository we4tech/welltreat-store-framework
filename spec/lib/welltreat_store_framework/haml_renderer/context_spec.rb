require 'spec_helper'

_DEFAULT_STORE_PATH = File.join(File.dirname(__FILE__), '../../../sample')

describe WelltreatStoreFramework::HamlRenderer::Context do

  before do
    WelltreatStoreFramework::Core.reset!
    WelltreatStoreFramework::Core.setup do |config|
      config.store_path  = _DEFAULT_STORE_PATH
      config.auto_reload = true
    end
  end

  let(:app) { WelltreatStoreFramework::Core.find_store_by_name('hello-store') }
  let(:request) { WelltreatStoreFramework::Controller::Request.new }
  let(:response) { WelltreatStoreFramework::Controller::Response.new }
  let(:context) { WelltreatStoreFramework::HamlRenderer::Context.new(app, request, response) }

  describe '#image_tag' do
    it 'should render img tag' do
      context.image_tag("abc.png").should == "<img src='/assets/images/abc.png' />"
    end

    it 'should add attributes' do
      context.image_tag("abc.png", alt: "hi").should == "<img alt='hi' src='/assets/images/abc.png' />"
    end
  end

  describe '#link_to' do
    it 'should render link tag' do
      context.link_to("Label", "http://abc.com").should == "<a href='http://abc.com'>Label</a>"
    end

    it 'should render link tag with attributes' do
      context.link_to("Label", "http://abc.com", id: 'hola').should == "<a id='hola' href='http://abc.com'>Label</a>"
    end
  end

  describe '#stylesheet_link_tag' do
    it 'should render link tag' do
      context.stylesheet_link_tag("abc", "def").should ==
          %{<link rel='stylesheet' type='text/css' href='/assets/stylesheets/abc.css' /><link rel='stylesheet' type='text/css' href='/assets/stylesheets/def.css' />}
    end
  end

  describe '#javascript_include_tag' do
    it 'should render script tag' do
      context.javascript_include_tag('abc', 'def').should ==
          %{<script type='text/javascript' src='/assets/javascripts/abc.js'></script><script type='text/javascript' src='/assets/javascripts/def.js'></script>}
    end
  end

  describe '#truncate' do
    it 'should truncate text' do
      context.truncate("hi" * 100, :length => 5).should == 'hihih'
    end
  end

  describe '#lorem' do
    it 'should return a line'
  end
end