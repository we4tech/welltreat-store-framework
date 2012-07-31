require 'welltreat_store_framework/haml_renderer/context'
require 'welltreat_store_framework/haml_renderer/url_join'

module WelltreatStoreFramework
  module HamlRenderer
    extend ActiveSupport::Concern

    # Render HAML template and set content in response.content variable
    def render!(request, response, options)
      return if response.redirect?
      return if response.content.present?

      _layout_key    = response.layout.to_s
      _template_key  = [
          response.controller_name,
          response.layout.to_s,
          response.template.to_s,
      ].join('_')
      _template_file = _full_template_path(response)
      _layout_file   = _full_layout_path(response)

      raise StoreApp::TemplateNotFound.new(_template_key) if _template_file.nil?

      # Render view with layout
      context = Context.new(self, request, response, options)

      # Render sub view
      context.set :body, _singleton_haml_instance(_template_key, _template_file).render(context)

      # Render layout
      response.content = _singleton_haml_instance(_layout_key, _layout_file).render(context)
    end

    def _singleton_haml_instance(_key, _file)
      raise StoreApp::TemplateNotFound.new(_file) if _file.nil? || !File.exist?(_file)

      if WelltreatStoreFramework::Core.configuration.auto_reload
        Haml::Engine.new(File.read(_file), filename: _file, encoding: 'UTF-8')
      else
        _haml_engines[_key] ||=
            Haml::Engine.new(File.read(_file), filename: _file)
      end
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


  end
end