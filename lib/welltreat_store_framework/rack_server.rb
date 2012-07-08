module WelltreatStoreFramework
  class RackServer
    class AppObj
      attr_accessor :id

      def initialize(id)
        self.id = id
      end
    end

    attr_accessor :store_name, :partition_id, :app

    def initialize(store_name, partition_id)
      self.store_name   = store_name
      self.partition_id = partition_id
    end

    def call(env)
      _store = _find_store(env)
      if _store
        _store.call(env)
      else
        raise "Store - #{self.store_name} for partition - #{self.partition_id} not found."
      end
    end

    private

    def _find_store(env)
      request = Rack::Request.new(env)
      if 'development' == ENV['ENVIRONMENT'] || 'true' == request.params['reload']
        puts "Reloading application..."

        if self.app
          puts "Previous base module id #<#{self.app.base.object_id}>"
          self.app = nil
        end
      end

      self.app ||= _load_store
    end

    def _load_store
      store = WelltreatStoreFramework::Core.
          find_store_by_name(self.store_name, AppObj.new(self.partition_id))

      return store if store.nil?

      store.tap do |_s|
        _s.start
        WelltreatStoreFramework::Core.connect_database!
      end

    end
  end
end