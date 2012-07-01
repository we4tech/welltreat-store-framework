module WelltreatStoreFramework
  module HamlRenderer
    module TagsHelper
      extend ActiveSupport::Concern

      # Render image tag
      def image_tag(_path, attrs = { })
        attrs[:src] = self.image_path(_path.to_s)
        content_tag 'img', nil, attrs
      end

      # Render link tag
      def link_to(label, link, attrs = { })
        attrs[:href] = link
        content_tag 'a', label, attrs
      end

      # Render stylesheet tags
      def stylesheet_link_tag(*_files)
        _files.map { |_f| stylesheet_path(_f) }.map do |_css_path|
          content_tag('link', nil, {
              rel: 'stylesheet',
              type: 'text/css',
              href: _css_path
          })
        end.join('')
      end

      # Render stylesheet tags
      def javascript_include_tag(*_files)
        _files.map { |_f| javascript_path(_f) }.map do |_js_path|
          content_tag('script', '', {
              type: 'text/javascript',
              src: _js_path
          })
        end.join('')
      end

      # Truncate text
      def truncate(text, options = {})
        length = options[:length] || 100
        text[0..length - 1]
      end

      def content_tag(tag_name, content, attrs = { })
        html = "<#{tag_name} #{_generate_attributes(attrs)}"

        if content
          html << ">"
          html << ERB::Util.html_escape(content)
          html << "</#{tag_name}>"

        elsif block_given?
          html << ">"
          html << ERB::Util.html_escape(yield)
          html << "</#{tag_name}>"
        else
          html << ' />'
        end

        html
      end

      private
      def _generate_attributes(_attrs)
        _attrs.map { |k, v| "#{k}='#{v}'" }.join(' ')
      end
    end
  end
end