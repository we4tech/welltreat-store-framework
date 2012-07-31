require 'welltreat_store_framework/haml_renderer/paths'
require 'welltreat_store_framework/haml_renderer/partial'
require 'welltreat_store_framework/haml_renderer/tags_helper'
require 'welltreat_store_framework/haml_renderer/lorem_helper'

module WelltreatStoreFramework
  module HamlRenderer
    class Context
      include Paths, Partial, TagsHelper, LoremHelper

      # Include Recaptcha helpers if it's provided
      include Rack::Recaptcha::Helpers if defined?(Rack::Recaptcha::Helpers)

      attr_accessor :request, :response, :options

      def initialize(app, request, response, options)
        @app      = app
        @request  = request
        @response = response
        @options  = options || { }
        @locals   = { }
      end

      def app;
        @app
      end

      def set_local(k, v)
        @locals[k] = v
      end

      def get_local(k)
        @locals[k]
      end

      def local_exists?(k)
        @locals.include?(k)
      end

      def local_present?(k)
        local_exists?(k) && get_local(k).present?
      end

      def session
        options[:session]
      end

      def notice
        get_flash :notice
      end

      def alert
        get_flash :alert
      end

      def success
        get_flash :success
      end

      def flash_exist?
        notice || alert || success
      end

      def get_flash(k)
        @flash_values    ||= { }
        @flash_values[k] ||= flash[k]
        flash[k] = nil if @flash_values[k].present?

        @flash_values[k]
      end

      def set_flash(k, v)
        flash[k] = v
      end

      def flash
        options[:session][:flash] ||= { }
      end

      delegate :exists?, :present?, :set, :get, :to => :response
    end

  end
end