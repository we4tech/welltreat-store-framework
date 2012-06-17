module WelltreatStoreFramework
  module HamlRenderer
    module Partial
      extend ActiveSupport::Concern

      # Render partial template
      #   template - Template file name
      #              By default look for relative path to current action path
      #              Otherwise check by relative path to views path
      #
      #   variables - Define local variables
      #
      # Return string content
      def partial(template, variables = { })
        _template_key = [
            self.response.controller_name,
            self.response.layout.to_s,
            self.response.template.to_s,
            template.to_s
        ].join('_')
        _file = self.app._full_partial_template_path(self.response, template)

        # Set local variables
        variables.each { |k, v| self.set_local(k, v) } if variables.present?

        # Render partial
        self.app._singleton_haml_instance(_template_key, _file).render(self)
      end
    end
  end
end