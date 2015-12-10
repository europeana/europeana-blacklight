module Europeana
  module Blacklight
    class SearchBuilder
      ##
      # Search builder methods for facet pagination
      module FacetPagination
        extend ActiveSupport::Concern

        included do
          default_processor_chain << :add_facet_paging_to_api
        end
        
        def add_facet_paging_to_api(api_parameters)
          return unless facet.present?

          facet_config = blacklight_config.facet_fields[facet]

          limit = if scope.respond_to?(:facet_list_limit)
              scope.facet_list_limit.to_s.to_i
            elsif api_parameters['facet.limit']
              api_parameters['facet.limit'].to_i
            else
              20
            end

          offset = (blacklight_params.fetch(blacklight_config.facet_paginator_class.request_keys[:page], 1).to_i - 1) * (limit)

          # Need to set as f.facet_field.facet.* to make sure we
          # override any field-specific default in the solr request handler.
          api_parameters[:"f.#{facet}.facet.limit"] = limit
          api_parameters[:"f.#{facet}.facet.offset"] = offset
          api_parameters[:rows] = 0
        end
      end
    end
  end
end

