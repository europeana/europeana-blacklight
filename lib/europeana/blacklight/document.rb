require 'blacklight'
require 'active_model'

module Europeana
  module Blacklight
    ##
    # A Europeana document
    class Document
      include ::Blacklight::Document

      attr_reader :_relations
      attr_writer :provider_id, :record_id
      attr_accessor :hierarchy

      class << self
        def lang_map?(obj)
          return false unless obj.is_a?(Hash)
          return false unless obj.keys.collect { |k| k.to_s.length }.max <= 3
          obj.values.reject { |v| v.is_a?(Array) }.size == 0
        end
      end

      def initialize(source_doc = {}, response = nil)
        source_doc_fields = {}
        @_relations = {}

        source_doc.each_pair do |k, v|
          if !v.is_a?(Enumerable) || v.none? { |val| val.is_a?(Enumerable) } || lang_map?(v)
            source_doc_fields[k] = v
          elsif v.is_a?(Hash)
            @_relations[k] = self.class.new(v, nil)
          else
            @_relations[k] = v.collect { |val| self.class.new(val, nil) }
          end
        end

        super(source_doc_fields, response)
      end

      def method_missing(m, *args, &b)
        if _relations_has_key?(m.to_s)
          _relations[m.to_s]
        else
          super
        end
      end

      def respond_to?(*args)
        (args.size == 1 && _relations_has_key?(*args)) || super
      end

      def respond_to_missing?(*args)
        (args.size == 1 && _relations_has_key?(*args)) || super
      end

      def _relations_has_key?(key)
        _relations.key?(key.to_s)
      end

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
        super.merge('hierarchy' => @hierarchy.as_json(options)).tap do |json|
          _relations.each do |k, v|
            json[k] = v.as_json
          end
        end
      end

      # BL expects document to respond to MLT method
      # @todo Remove once BL expectation loosened, or; implement if Europeana
      #   API supports it
      def more_like_this
        []
      end

      def lang_map?(obj)
        self.class.lang_map?(obj)
      end
    end
  end
end
