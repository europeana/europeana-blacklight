module Europeana
  module Blacklight
    ##
    # Blacklight document presenter for Europeana documents
    class DocumentPresenter < ::Blacklight::DocumentPresenter
      include ActionView::Helpers::AssetTagHelper

      def render_document_show_field_value(field, options = {})
        value = super

        opts = options.reverse_merge({ tag: true })

        if field.match(/(\A|\.)edmPreview\Z/) && opts[:tag]
          value = image_tag(value)
        end

        value
      end
    end
  end
end
