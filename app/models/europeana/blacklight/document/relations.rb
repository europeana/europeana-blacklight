# frozen_string_literal: true

require 'active_support/core_ext/hash'

module Europeana
  module Blacklight
    class Document
      ##
      # Methods for working with relations between objects in Europeana documents
      module Relations
        attr_reader :relations

        def self.included(base)
          base.extend(ClassMethods)
        end

        module ClassMethods
          def split_edm_keys
            @split_edm_keys ||= {}
          end
        end

        def fetch_through_relation(key, *default)
          field = nested_field_key(key)
          container = nested_field_container(key)
          value = [container].flatten.compact.map do |target|
            target.fetch(field, *default)
          end.compact.flatten
        end

        def extract_relations(source_doc)
          fields = source_doc.except(relation_keys)

          relations = HashWithIndifferentAccess.new

          relation_keys.each do |k|
            if source_doc.key?(k)
              if source_doc[k].is_a?(Hash)
                relations[k] = self.class.new(source_doc[k], nil, self)
              elsif source_doc[k].is_a?(Array)
                relations[k] = source_doc[k].map { |v| self.class.new(v, nil, self) }
              else
                fail StandardError,
                     'Relations should be a collection of objects.'
              end
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
              container = [container].flatten.map { |d| d.send(relation_key.to_sym) }
            end
          end
          container
        end

        def method_missing(m, *args, &b)
          if has_relation?(m)
            relations[m.to_s]
          elsif relation_keys.include?(m)
            []
          else
            super
          end
        end

        def has?(k, *values)
          if !key?(k)
            false
          elsif values.empty?
            fetch(k, nil).present?
          else
            Array(values).any? do |expected|
              Array(fetch(k, nil)).any? do |actual|
                case expected
                when Regexp
                  actual =~ expected
                else
                  actual == expected
                end
              end
            end
          end
        end

        def key?(k)
          [nested_field_container(k)].flatten.any? do |container|
            container._source.key?(nested_field_key(k))
          end
        end

        def has_relation?(name)
          relations.key?(name.to_s)
        end

        protected

        def split_edm_key(key)
          self.class.split_edm_keys[key] ||= key.to_s.split('.')
        end

        def relation_keys
          %i(agents aggregations concepts europeanaAggregation licenses
             places providedCHOs proxies timespans webResources)
         end
      end
    end
  end
end
