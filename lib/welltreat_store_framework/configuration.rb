module WelltreatStoreFramework
  class Configuration
    attr_accessor :store_path, :haml_options, :database_config,
                  :database_schema_file, :auto_reload, :sprockets_enabled

    def initialize
      @auto_reload = false
      @store_path = nil
      @sprockets_enabled = false
      @haml_options = {
          encoding: 'utf-8',
          format: :html5
      }
      @database_connection = nil
    end
  end
end