# frozen_string_literal: true

require 'rails_helper'

module Bitcoin
  describe PriceDataFetcher do
    let(:params) { { start: '2018-08-01', end: '2018-08-08', currency: 'USD' } }
    let(:filterForm) { FilterForm.new(params) }
    let(:requestResults) { 'test value' }
    subject { described_class.new(filterForm) }

    describe '#call' do
      it 'returns correct value' do
        allow(HTTP).to receive(:get)
          .with(described_class::API_URL, params: params)
          .and_return(requestResults)

        expect(subject.call).to eq('test value')
      end
    end
  end
end
