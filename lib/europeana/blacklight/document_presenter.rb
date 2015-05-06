module Europeana
  module Blacklight
    ##
    # Blacklight document presenter for Europeana documents
    class DocumentPresenter < ::Blacklight::DocumentPresenter
      include ActionView::Helpers::AssetTagHelper

      def field_in_relation?(field)
        keys = split_edm_key(field)
        (keys.size > 1) && @document._relations_has_key?(keys.first)
      end

      def render_relation_field_value(field, context, options = {})
        doc = @document

        if field_in_relation?(field)
          keys = split_edm_key(field)
          field = keys.last
          keys[0..-2].each do |relation_key|
            doc = [doc].flatten.collect { |d| d._relations[relation_key] }
          end
        end

        field_config = @configuration.send(:"#{context}_fields")[field]
        value = options[:value] || begin
          [doc].flatten.collect do |target|
            case target
            when NilClass
              nil
            else
              presenter = self.class.new(target, @controller, @configuration)
              presenter.get_field_values(field, field_config, options)
            end
          end.compact.flatten
        end

        render_field_value(value, field_config)
      end

      def render_document_show_field_value(field, options = {})
        render_relation_field_value(field, :show, options)
      end

      def render_index_field_value(field, options = {})
        render_relation_field_value(field, :index, options)
      end

      def get_field_values(field, field_config, options = {})
        values = super
        if Document.lang_map?(values)
          values = localize_lang_map(values)
        end
        values
      end

      protected

      def split_edm_key(key)
        key.to_s.split('.')
      end

      def localize_lang_map(lang_map)
        if lang_map.key?(I18n.locale)
          lang_map[I18n.locale]
        elsif lang_map.key?(:def)
          lang_map[:def]
        else
          lang_map.values
        end
      end
    end
  end
end
