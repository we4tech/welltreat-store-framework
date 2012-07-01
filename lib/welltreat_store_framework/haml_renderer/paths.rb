module WelltreatStoreFramework
  module HamlRenderer
    module Paths
      extend ActiveSupport::Concern

      def asset_path(*_paths)
        UrlJoin.new('/assets').join(_paths)
      end

      def image_path(_path)
        if sprockets_enabled?
          asset_path _path
        else
          asset_path 'images', _path
        end
      end

      def stylesheet_path(_path)
        _path = _path.to_s
        _path << '.css' unless _path.to_s.match(/\.css$/)

        if sprockets_enabled?
          asset_path _path
        else
          asset_path 'stylesheets', _path
        end
      end

      def javascript_path(_path)
        _path = _path.to_s
        _path << '.js' unless _path.to_s.match(/\.js$/)

        if sprockets_enabled?
          asset_path _path
        else
          asset_path 'javascripts', _path
        end
      end

      def sprockets_enabled?
        WelltreatStoreFramework::Core.configuration.sprockets_enabled
      end
    end
  end
end