require 'spec_helper'

describe ApiPagination do
  let(:collection) {(1..100).to_a}
  let(:paginate_array_options) {{ total_count: 1000 }}

  describe "#paginate" do
    if ENV['PAGINATOR'].to_sym == :kaminari
      context 'Using kaminari' do
        it 'should accept paginate_array_options option' do
          expect(Kaminari).to receive(:paginate_array)
                                .with(collection, paginate_array_options)
                                .and_call_original

          ApiPagination.paginate(
            collection,
            {
              per_page:               30,
              paginate_array_options: paginate_array_options
            }
          )
        end

        describe '.pages_from' do
          subject { described_class.pages_from(collection) }

          context 'on empty collection' do
            let(:collection) { ApiPagination.paginate([], page: 1).first }

            it { is_expected.to be_empty }
          end
        end
      end
    end

    if ENV['PAGINATOR'].to_sym == :will_paginate
      context 'Using will_paginate' do
        context 'passing in total_entries in options' do
          it 'should set total_entries using the passed in value' do
            paginated_collection = ApiPagination.paginate(collection, total_entries: 3000).first
            expect(paginated_collection.total_entries).to eq(3000)
          end
        end

        context 'passing in collection only' do
          it 'should set total_entries using the size of the collection ' do
            paginated_collection = ApiPagination.paginate(collection).first
            expect(paginated_collection.total_entries).to eq(100)
          end
        end
      end
    end
  end
end
