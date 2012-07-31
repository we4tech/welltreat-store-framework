module WelltreatStoreFramework
  module HamlRenderer
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