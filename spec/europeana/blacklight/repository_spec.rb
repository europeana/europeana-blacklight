RSpec.describe Europeana::Blacklight::Repository do
  let(:blacklight_config) do
    Blacklight::Configuration.new.tap do |config|
      config.connection_config = { europeana_api_key: api_key }
      config.repository_class = Europeana::Blacklight::Repository
      config.search_builder_class = Europeana::Blacklight::SearchBuilder
      config.response_model = Europeana::Blacklight::Response
      config.document_model = Europeana::Blacklight::Document
      config.document_presenter_class = Europeana::Blacklight::DocumentPresenter
    end
  end
  let(:api_key) { 'my_key' }

  subject { described_class.new(blacklight_config) }

  describe '#connection' do
    it 'should uses Europeana::API' do
      expect(subject.connection).to eq(Europeana::API)
    end
  end

  describe '#find' do
    let(:record_id) { '/abc/123' }

    it 'should send a record query to the API' do
      subject.find(record_id)
      expect(a_request(:get, "https://www.europeana.eu/api/v2/record#{record_id}.json").
        with(query: hash_including({ 'wskey' => api_key }))).to have_been_made
    end

    it 'should pass on API query params' do
      subject.find(record_id, callback: 'showRecord')
      expect(a_request(:get, "https://www.europeana.eu/api/v2/record#{record_id}.json").
        with(query: hash_including({ 'wskey' => api_key, 'callback' => 'showRecord' }))).to have_been_made
    end

    it 'should return configured response model' do
      expect(subject.find(record_id)).to be_a(blacklight_config.response_model)
    end
  end

  describe '#search' do
    let(:query) { 'opera' }

    it 'should send a search query to the API' do
      subject.search('query' => query)
      expect(a_request(:get, 'https://www.europeana.eu/api/v2/search.json').
        with(query: hash_including({ 'wskey' => api_key, 'query' => query }))).to have_been_made
    end

    it 'should return configured response model' do
      expect(subject.search('query' => query)).to be_a(blacklight_config.response_model)
    end
  end
end
