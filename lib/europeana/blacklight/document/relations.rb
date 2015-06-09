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
          fields = {}
          relations = HashWithIndifferentAccess.new

          source_doc.each_pair do |k, v|
            if !v.is_a?(Enumerable) || v.none? { |val| val.is_a?(Enumerable) } || lang_map?(v)
              fields[k] = v
            elsif v.is_a?(Hash)
              relations[k] = self.class.new(v, nil)
            else
              relations[k] = v.collect { |val| self.class.new(val, nil) }
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

        protected

        def split_edm_key(key)
          key.to_s.split('.')
        end
      end
    end
  end
end
