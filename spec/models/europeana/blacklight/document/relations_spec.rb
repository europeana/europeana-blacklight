# frozen_string_literal: true

RSpec.describe Europeana::Blacklight::Document::Relations do
  subject { Europeana::Blacklight::Document.new(source) }

  context 'when relation is missing from source' do
    let(:source) { { id: '/abc/123', title: ['test'] } }

    it 'returns an empty array' do
      %i(agents aggregations concepts europeanaAggregation places
         providedCHOs proxies timespans).each do |relation|
        expect(subject.send(relation)).to eq([])
      end
    end
  end
end
