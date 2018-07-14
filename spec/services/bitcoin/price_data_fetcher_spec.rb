# frozen_string_literal: true

require 'rails_helper'

module Bitcoin
  describe PriceDataFetcher do
    let(:params) { { start: '2018-08-01', end: '2018-08-08', currency: 'USD' } }
    let(:filterForm) { FilterForm.new(params) }

    subject { described_class.new(filterForm) }

    shared_examples 'fetcher assigning correct data to response' do
      it 'assigns correct value to response' do
        subject.call
        expect(subject.response).to equal(response)
      end
    end

    describe '#call' do
      before do
        allow(HTTP).to receive(:get)
          .with(described_class::API_URL, params: params)
          .and_return(response)
      end

      context 'when response is successful' do
        let(:response) { double(status: 200) }

        it 'returns true' do
          expect(subject.call).to be true
        end

        it_behaves_like 'fetcher assigning correct data to response'
      end

      context 'when response is unsuccessful' do
        let(:response) { double(status: 500) }

        it 'returns false' do
          expect(subject.call).to be false
        end

        it_behaves_like 'fetcher assigning correct data to response'
      end
    end
  end
end
