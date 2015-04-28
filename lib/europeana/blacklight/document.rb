require 'blacklight'
require 'active_model'

module Europeana
  module Blacklight
    ##
    # A Europeana document
    class Document
      include ::Blacklight::Document

      attr_writer :provider_id, :record_id
      attr_accessor :hierarchy

      def to_param
        "#{provider_id}/#{record_id}"
      end

      def provider_id
        @provider_id ||= self['id'].to_s.split('/')[1]
      end

      def record_id
        @record_id ||= self['id'].to_s.split('/')[2]
      end

      def as_json(options = nil)
        super.merge('hierarchy' => @hierarchy.as_json(options))
      end

      def has?(k, *values)
        keys = split_edm_key(k)
        return super unless keys.size > 1

        edm = fetch(k)

        if edm.nil?
          false
        elsif values.nil?
          true
        else
          edm_field_has_value?(edm, values)
        end
      end

      def [](key)
        val = get_localized_edm_value(edm_target(key))
        val.is_a?(Array) ? val.compact.flatten : val
      end

      def key?(key)
        !edm_target(key).nil?
      end

      # BL expects document to respond to MLT method
      # @todo Remove once BL expectation loosened, or; implement if Europeana
      #   API supports it
      def more_like_this
        []
      end

      protected

      def edm_field_has_value?(field, val)
        if field.is_a?(Array)
          if val.is_a?(Array)
            (val - field).size == 0
          else
            field.include?(val)
          end
        else
          if val.is_a?(Array)
            val.include?(field)
          else
            val == field
          end
        end
      end

      def edm_target(key)
        target = _source
        split_edm_key(key).each do |k|
          target = get_edm_child(target, k)
          return nil if target.nil?
        end
        target
      end

      def split_edm_key(key)
        key.to_s.split('.')
      end

      def get_localized_edm_value(val)
        if val.is_a?(Array)
          val.collect do |v|
            get_localized_edm_value(v)
          end
        elsif val.is_a?(Hash) && hash_is_lang_map?(val)
          if val.key?(I18n.locale)
            val[I18n.locale]
          elsif val.key?(:def)
            val[:def]
          else
            val.values
          end
        else
          val
        end
      end

      def hash_is_lang_map?(hash)
        return false unless hash.keys.collect { |k| k.to_s.length }.max <= 3
        hash.values.reject { |v| v.is_a?(Array) }.size == 0
      end

      def get_edm_child(parent, child_key)
        if parent.is_a?(Array)
          child = []
          parent.compact.each do |v|
            if v[child_key].is_a?(Array)
              child += v[child_key]
            elsif v.key?(child_key)
              child << v[child_key]
            end
          end
          child.empty? ? nil : child
        elsif parent.respond_to?(:'[]')
          parent[child_key]
        end
      end
    end
  end
end
