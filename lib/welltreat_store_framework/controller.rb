module WelltreatStoreFramework
  module Controller
    extend ActiveSupport::Concern

    attr_reader :app

    def initialize(app)
      @app = app
    end

    def serve(request)
    end

    [:notice, :alert, :success].map(&:to_s).each do |_kind|
      module_eval <<-CODE
        def set_flash_#{_kind}(session, msg)
          _flash_from(session)[:#{_kind}] = msg
        end

        def get_flash_#{_kind}(session)
          _flash_from(session)[:#{_kind}]
        end
      CODE
    end

    def _flash_from(session)
      session[:flash] ||= { }
    end

    class Request
      attr_accessor :path, :params, :headers, :rack_request, :env

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
              :path         => request.path,
              :env          => env
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

      def redirect_to(path, status = 302)
        self.status = status
        self.add_header("Location", path)
        self.content = ''
      end

      def redirect?
        [301, 302, 303, 307].include? self.status
      end

    end
  end
end