module WelltreatStoreFramework
  class Configuration
    attr_accessor :store_path, :haml_options, :database_config, :database_schema_file

    def initialize
      @store_path = nil
      @haml_options = {
          encoding: 'utf-8',
          format: :html5
      }
      @database_connection = nil
    end
  end
end