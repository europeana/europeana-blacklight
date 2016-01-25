RSpec.describe Europeana::Blacklight::Document::MoreLikeThis do
  subject { Europeana::Blacklight::Document.new(source) }
  let(:source) { {} }

  describe '#more_like_this_query' do
    context 'without param arg' do
      context 'when doc has no MLT fields' do
        it 'returns nil' do
          expect(subject.more_like_this_query).to be_nil
        end
      end

      context 'when doc has one MLT field' do
        let(:source) { { id: '/abc/123', title: ['test'] } }
        it 'includes query for that field' do
          expect(subject.more_like_this_query).to match(/title: \("test"\)/)
        end
        it 'excludes doc by ID' do
          expect(subject.more_like_this_query).to match(/ NOT europeana_id:"#{source[:id]}"/)
        end
        context 'when query has special chars' do
          let(:source) { { id: '/abc/123', title: ['test & "pass"'] } }
          it 'escapes special chars' do
            expect(subject.more_like_this_query).to match(/title: \("test \\& \\"pass\\""\)/)
          end
        end
      end

      context 'when doc has multiple MLT fields' do
        let(:source) { { id: '/abc/123', title: ['test'], proxies: [{ dcType: 'book' }] } }
        it 'includes queries for all those fields' do
          expect(subject.more_like_this_query).to match(/title: \("test"\)/)
          expect(subject.more_like_this_query).to match(/what: \("book"\)/)
        end
        it 'combines queries with OR' do
          expect(subject.more_like_this_query).to match(/ OR /)
        end
        it 'excludes doc by ID' do
          expect(subject.more_like_this_query).to match(/ NOT europeana_id:"#{source[:id]}"/)
        end
      end
    end

    context 'with param arg' do
      context 'when doc has multiple MLT fields' do
        let(:source) { { id: '/abc/123', title: ['test'], proxies: [{ dcType: 'book' }] } }
        it 'includes queries for param arg fields' do
          expect(subject.more_like_this_query('title')).to match(/title: \("test"\)/)
        end
        it 'omits queries for other fields' do
          expect(subject.more_like_this_query('title')).not_to match(/what: /)
        end
        it 'excludes doc by ID' do
          expect(subject.more_like_this_query('title')).to match(/ NOT europeana_id:"#{source[:id]}"/)
        end
      end
    end
  end
end
