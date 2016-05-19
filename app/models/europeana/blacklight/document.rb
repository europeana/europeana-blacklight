require 'active_model'
require 'iso-639'

module Europeana
  module Blacklight
    ##
    # A Europeana document
    class Document
      include ActiveModel::Conversion
      include ::Blacklight::Document
      include ::Blacklight::Document::ActiveModelShim
      include LangMaps
      include MoreLikeThis
      include Relations

      attr_reader :root
      attr_writer :provider_id, :record_id

      class << self
        def model_name
          @_model_name ||= begin
            ActiveModel::Name.new(self, nil, 'Document')
          end
        end
      end

      def initialize(source_doc = {}, response = nil, root = self)
        fields, @relations = extract_relations(source_doc)
        @root = root
        super(fields, response)
      end

      def id
        return @id unless @id.nil?
        @id = (self['id'] || self['about']).sub(%r{^//}, '/')
      end

      def fetch(key, *default)
        value = if has_relation?(key)
          relations[key]
        elsif field_in_relation?(key)
          fetch_through_relation(key, *default)
        else
          super
        end
        localize_lang_map(value)
      end

      def respond_to?(*args)
        (args.size == 1 && relations.key?(*args)) || super
      end

      def respond_to_missing?(*args)
        (args.size == 1 && relations.key?(*args)) || super
      end

      def to_param
        "#{provider_id}/#{record_id}"
      end

      def persisted?
        true
      end

      def private?(_exhibit)
        false
      end

      def public?(_exhibit)
        true
      end

      def provider_id
        @provider_id ||= id.to_s.split('/')[1]
      end

      def record_id
        @record_id ||= id.to_s.split('/')[2]
      end

      def as_json(options = {})
        super.tap do |json|
          relations.each do |k, v|
            json[k] = v.as_json
          end
        end
      end
    end
  end
end
