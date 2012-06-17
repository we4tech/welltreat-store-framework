module WelltreatStoreFramework
  module Controller
    extend ActiveSupport::Concern

    attr_reader :app

    def initialize(app)
      @app = app
    end

    def serve(request)

    end

    class Request
      attr_accessor :path, :params, :headers, :rack_request

      def initialize(attrs = { })
        @headers      = { }
        @params       = { }
        @path         = nil
        @rack_request = nil
        attrs.each do |k, v|
          self.send(:"#{k.to_s}=", v)
        end
      end

      def get_header(k)
        self.headers[k]
      end

      def [](k)
        self.params[k]
      end

      class << self
        def initialize_from_env(env)
          request = Rack::Request.new(env)
          self.new(
              :params       => request.params,
              :headers      => env,
              :rack_request => request,
              :path         => request.path
          )
        end
      end


      private
      def set_param(k, v)
        self.params[k] = v
      end
    end

    class Response

      STATUS_OK = 200
      attr_accessor :status, :headers, :content, :values,
                    :controller_name, :template, :layout

      def initialize
        @status   = STATUS_OK
        @headers  = { 'Content-Type' => 'text/html' }
        @content  = nil
        @template = nil
        @layout   = :default
        @values   = { }
      end

      def add_header(k, v)
        case k.to_s
          when 'content_type', 'format'
            @headers['Content-Type'] = v
          else
            @headers[k] = v
        end
      end

      def get_header(k)
        @headers[k]
      end

      def set(k, v)
        @values[k] = v
      end

      def get(k)
        @values[k]
      end

      def [](k)
        self.get(k)
      end

      def exists?(k)
        @values.include?(k)
      end

      def present?(k)
        exists?(k) && get(k).present?
      end
    end
  end
end