module WelltreatStoreFramework
  class StoreApp

    # Declare exceptions
    class ControllerNotFound < StandardError
      attr_accessor :controller_name
      def initialize(_c_name)
        super "Controller - #{_c_name} not found."
        self.controller_name = _c_name
      end
    end
    class ActionNotFound < StandardError
      attr_accessor :action_name, :controller_name
      def initialize(_a_name, _c_name)
        super "Action - #{_a_name} from controller - #{_c_name} not found."
        self.action_name = _a_name
        self.controller_name = _c_name
      end
    end
    class ExecutionError < StandardError;
    end
    class TemplateNotFound < StandardError;
    end
    class TemplateRenderingError < StandardError;
    end

    # Include haml support
    if defined?(Haml)
      require 'welltreat_store_framework/haml_renderer'
      include WelltreatStoreFramework::HamlRenderer
    else
      raise "No such haml found. Use gem 'haml' in your Gemfile"
    end


    # Declare attribute accessors
    attr_accessor :name, :path, :config_path, :routes_path,
                  :controllers_path, :models_path, :views_path, :assets_path,
                  :controllers, :models, :views, :started

    # Default constructor with attribute hash, if attribute hash is passed
    # it will set value through setter accessors
    def initialize(attrs = { })
      if attrs.present?
        attrs.each do |k, v|
          self.send(:"#{k}=", v)
        end
      end
    end

    # Start application
    # Return true if successful otherwise false
    def start
      _bootstrap!
      self.started = true
    end

    # Dispose and stop application
    # Return true if successful otherwise false
    def stop
      if self.started
        _dispose!
        self.started = false
        true
      else
        false
      end
    end

    # Stop and start application
    def restart
      if self.started
        self.stop
        self.start
        true
      else
        false
      end
    end

    # Handle request for the specified path and request
    # Return status and html content string
    def dispatch(path, request, response)
      case path
        when '/'
          _execute_action(:Home, :index, request, response)
        else
          _controller_name, _action, _id = self.send(:_extract_path, path)
          request.send(:set_param, :id, _id)

          _execute_action(_controller_name, _action, request, response)
      end
    end

    def models
      _base_module::Models
    end

    # Make it rack compatible
    def call(env)
      request  = WelltreatStoreFramework::Controller::Request.
          initialize_from_env(env)
      response = WelltreatStoreFramework::Controller::Response.new

      dispatch request.path, request, response
      render! request, response

      [response.status, response.headers, [response.content]]
    end

    private
    def _execute_action(_controller_name, _action, request, response)
      _controller_inst = _find_controller_inst(_controller_name)
      _check_action_existence!(_controller_inst, _action)

      # Set default template
      response.template        = _action
      response.controller_name = _controller_name

      # Execute action
      _controller_inst.send(_action, request, response)
    end

    def _check_action_existence!(_controller_inst, _action)
      raise ActionNotFound.new(_action, _controller_inst.name) unless _controller_inst.respond_to?(_action)
    end

    def _find_controller_inst(controller_name)
      _check_controller_existence!(controller_name)
      _singleton_instance(_base_module::Controllers::const_get(controller_name))
    end

    def _check_controller_existence!(controller_name)
      _controller = _all_controllers.select { |c| c == controller_name }.first
      raise ControllerNotFound.new(controller_name) if _controller.nil?
    end

    def _singleton_instance(clazz)
      @_instances             ||= { }
      @_instances[clazz.name] ||= clazz.new(self)
    end

    def _all_controllers
      @_all_controllers ||= _base_module::Controllers.constants
    end

    def _all_controllers=(v)
      @_all_controllers = v
    end

    def _extract_path(path)
      _parts = path.split('/')[1..9999]

      _controller_name = _parts.first.to_s.camelize.to_sym
      _action          = if _parts.length > 1
        _parts[1]
      else
        :index
      end

      _id = if _parts.length > 2
        _parts.last
      else
        nil
      end

      [_controller_name, _action, _id]
    end

    def _dispose!
      self.class.send(:remove_const, self.send(:_base_module_name))
      self._base_module     = nil
      self._all_controllers = nil
    end

    def _bootstrap!
      _base_module
    end

    def _base_module
      @_base_module ||= _create_base_module
    end

    def _base_module=(mod)
      @_base_module = mod
    end

    def _base_module_name
      self.send(:_base_module).name.split('::').last
    end

    def _create_base_module
      mod_name = "#{self.name.capitalize}#{Time.now.to_i}".tableize.camelize
      eval <<-RUBY
        module #{mod_name}

          module Controllers
            WelltreatStoreFramework::StoreApp::AppStack.load_classes(self, "#{self.controllers_path}")
          end

          module Models
            WelltreatStoreFramework::StoreApp::AppStack.load_classes(self, "#{self.models_path}")
          end

        end

        #{mod_name}
      RUBY
    end


    # Provide utilities for bootstrapping new app stack
    class AppStack
      class << self

        def load_classes(_mod, _path)
          if _path.match(/\.rb$/)
            _mod.module_eval File.read(_path)
          else
            Dir.glob(File.join(_path, "*.rb")).each do |_file|
              _mod.module_eval File.read(_file)
            end
          end
        end
      end
    end

  end
end