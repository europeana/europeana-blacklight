module Europeana
  module Blacklight
    ##
    # Blacklight document presenter for Europeana documents
    class DocumentPresenter < ::Blacklight::DocumentPresenter
      include ActionView::Helpers::AssetTagHelper # ?

      def render_document_show_field_value(field, options = {})
        render_nested_field_value(field, :show, options)
      end

      def render_index_field_value(field, options = {})
        render_nested_field_value(field, :index, options)
      end

      def render_nested_field_value(field, context, options = {})
        key = @document.nested_field_key(field)
        container = @document.nested_field_container(field)

        field_config = @configuration.send(:"#{context}_fields")[key]
        value = options[:value] || begin
          [container].flatten.compact.collect do |target|
            presenter = self.class.new(target, @controller, @configuration)
            presenter.get_field_values(key, field_config, options)
          end.compact.flatten
        end

        render_field_value(value, field_config)
      end

      def get_field_values(field, field_config, options = {})
        Document.localize_lang_map(super)
      end
    end
  end
end
