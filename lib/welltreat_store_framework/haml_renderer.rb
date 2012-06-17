require 'welltreat_store_framework/haml_renderer/partial'

module WelltreatStoreFramework
  module HamlRenderer
    extend ActiveSupport::Concern

    # Render HAML template and set content in response.content variable
    def render!(request, response)
      _layout_key    = response.layout.to_s
      _template_key  = [
          response.controller_name,
          response.layout.to_s,
          response.template.to_s,
      ].join('_')
      _template_file = _full_template_path(response)
      _layout_file   = _full_layout_path(response)

      raise StoreApp::TemplateNotFound if _template_file.nil?

      # Render view with layout
      context = Context.new(self, request, response)

      # Render sub view
      context.set :body, _singleton_haml_instance(_template_key, _template_file).render(context)

      # Render layout
      response.content = _singleton_haml_instance(_layout_key, _layout_file).render(context)
    end

    def _singleton_haml_instance(_key, _file)
      _haml_engines[_key] ||=
          Haml::Engine.new(File.read(_file), filename: _file)
    end

    def _haml_engines
      @_haml_engines ||= { }
    end

    def _full_layout_path(response)
      Dir.glob(File.join(self.views_path,
                         'layouts',
                         "#{response.layout.to_s}.*"
               )).first
    end

    def _full_template_path(response)
      Dir.glob(File.join(self.views_path,
                         response.controller_name.to_s.underscore,
                         "#{response.template.to_s}.*"
               )).first
    end

    def _full_partial_template_path(response, _partial)
      Dir.glob(File.join(self.views_path,
                         response.controller_name.to_s.underscore,
                         "#{_partial.to_s}.*"
               )).first ||
          Dir.glob(File.join(self.views_path,
                             "#{_partial.to_s}.*"
                   )).first
    end

    class Context
      include WelltreatStoreFramework::HamlRenderer::Partial
      attr_accessor :request, :response

      def initialize(app, request, response)
        @app      = app
        @request  = request
        @response = response
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

      def asset_path(*_paths)
        UrlJoin.new('/assets').join(_paths)
      end

      def image_path(_path)
        asset_path 'images', _path
      end

      def stylesheet_path(_path)
        _path = _path.to_s
        _path << '.css' unless _path.to_s.match(/\.css$/)
        asset_path 'stylesheets', _path
      end

      def javascript_path(_path)
        _path = _path.to_s
        _path << '.js' unless _path.to_s.match(/\.js$/)
        asset_path 'javascripts', _path
      end

      delegate :exists?, :present?, :set, :get, :to => :response
    end

    class UrlJoin
      def initialize(*_base_paths)
        @paths = []
        join(_base_paths)
      end

      def join(*_paths)
        @paths += _paths
        self
      end

      def to_s
        @paths.join('/')
      end
    end
  end
end