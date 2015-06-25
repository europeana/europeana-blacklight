require 'blacklight'
require 'active_model'

module Europeana
  module Blacklight
    ##
    # A Europeana document
    class Document
      autoload :MoreLikeThis, 'europeana/blacklight/document/more_like_this'
      autoload :Relations, 'europeana/blacklight/document/relations'

      include ActiveModel::Conversion
      include ::Blacklight::Document
      include MoreLikeThis
      include Relations

      attr_writer :provider_id, :record_id
      attr_accessor :hierarchy

      class << self
        def lang_map?(obj)
          return false unless obj.is_a?(Hash)
          return false unless obj.keys.collect { |k| k.to_s.length }.max <= 3
          obj.values.reject { |v| v.is_a?(Array) }.size == 0
        end

        def localize_lang_map(lang_map)
          return lang_map unless lang_map?(lang_map)
          if lang_map.key?(I18n.locale)
            lang_map[I18n.locale]
          elsif lang_map.key?(:def)
            lang_map[:def]
          else
            lang_map.values
          end
        end

        def model_name
          @_model_name ||= begin
            ActiveModel::Name.new(self, nil, 'Document')
          end
        end
      end

      def initialize(source_doc = {}, response = nil)
        fields, @relations = extract_relations(source_doc)
        super(fields, response)
      end

      def id
        self['id'] || self['about']
      end

      def fetch(key, *default)
        value = if has_relation?(key)
          relations[key]
        elsif field_in_relation?(key)
          fetch_through_relation(key, *default)
        else
          super
        end
        Document.localize_lang_map(value)
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

      def private?(exhibit)
        !public?(exhibit)
      end

      def public?(exhibit)
        true
      end

      def provider_id
        @provider_id ||= self['id'].to_s.split('/')[1]
      end

      def record_id
        @record_id ||= self['id'].to_s.split('/')[2]
      end

      def as_json(options = nil)
        super.merge('hierarchy' => @hierarchy.as_json(options)).tap do |json|
          relations.each do |k, v|
            json[k] = v.as_json
          end
        end
      end

      def lang_map?(obj)
        self.class.lang_map?(obj)
      end

      def localize_lang_map(lang_map)
        self.class.localize_lang_map(lang_map)
      end
    end
  end
end
