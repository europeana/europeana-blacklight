require 'active_support/core_ext/hash'

module Europeana
  module Blacklight
    class Document
      ##
      # Methods for working with relations between objects in Europeana documents
      module Relations
        attr_reader :relations

        def fetch_through_relation(key, *default)
          field = nested_field_key(key)
          container = nested_field_container(key)
          value = [container].flatten.compact.collect do |target|
            target.fetch(field, *default)
          end.compact.flatten
        end

        def extract_relations(source_doc)
          relation_keys = [:agents, :aggregations, :concepts,
                           :europeanaAggregation, :places, :providedCHOs,
                           :proxies, :timespans]

          fields = source_doc.except(relation_keys)

          relations = HashWithIndifferentAccess.new

          relation_keys.each do |k|
            if source_doc.key?(k)
              if source_doc[k].is_a?(Hash)
                relations[k] = self.class.new(source_doc[k], nil)
              elsif source_doc[k].is_a?(Array)
                relations[k] = source_doc[k].map { |v| self.class.new(v, nil) }
              else
                fail StandardError,
                     'Relations should be a collection of objects.'
              end
            else
              relations[k] = []
            end
          end

          [fields, relations]
        end

        def field_in_relation?(field)
          keys = split_edm_key(field)
          (keys.size > 1) && relations.key?(keys.first)
        end

        def nested_field_key(field)
          split_edm_key(field).last
        end

        def nested_field_container(field)
          container = self
          if field_in_relation?(field)
            keys = split_edm_key(field)
            field = keys.last
            keys[0..-2].each do |relation_key|
              container = [container].flatten.collect { |d| d.send(relation_key.to_sym) }
            end
          end
          container
        end

        def method_missing(m, *args, &b)
          has_relation?(m) ? relations[m.to_s] : super
        end

        def has_relation?(name)
          relations.key?(name.to_s)
        end

        protected

        def split_edm_key(key)
          key.to_s.split('.')
        end
      end
    end
  end
end
