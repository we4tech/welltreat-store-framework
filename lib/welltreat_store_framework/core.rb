module WelltreatStoreFramework
  class Core
    @@configuration = WelltreatStoreFramework::Configuration.new
    cattr_accessor :configuration

    @@stores = nil
    cattr_accessor :stores

    class << self

      # Reset internal cached data
      def reset!
        self.stores        = nil
        self.configuration = WelltreatStoreFramework::Configuration.new
      end

      # Configure through passing block. block will be yield with
      # configuration instance
      def setup(&block)
        block.call(self.configuration)
      end

      # Find all stores from the configured path
      # return an array of instance StoreApp
      def find_stores(partition_object = nil)
        self.stores ||= _detect_stores(partition_object)
      end

      # Find store by the given name
      # Return StoreApp instance
      def find_store_by_name(name, partition_object = nil)
        find_stores(partition_object)[name]
      end

      # Establish database connection
      def connect_database!
        ActiveRecord::Base.establish_connection configuration.database_config

        if configuration.database_schema_file.present?
          puts "Importing database schema - "
          require configuration.database_schema_file
        end
      end

      private
      def _detect_stores(partition_object = nil)
        _stores = { }
        Dir.glob(File.join(configuration.store_path, '*')).each do |_path|
          _name          = _path.split('/').last
          _stores[_name] = StoreApp.new.tap do |inst|
            inst.partition_object = partition_object
            inst.path             = _path
            inst.name             = _name
            inst.config_path      = File.join(_path, 'config')
            inst.controllers_path = File.join(_path, 'controllers')
            inst.models_path      = File.join(_path, 'models')
            inst.views_path       = File.join(_path, 'views')
            inst.assets_path      = File.join(_path, 'assets')
          end
        end

        _stores
      end
    end
  end
end