API_URL="https://api.coindesk.com/v1/bpi/historical/close.json"

module Bitcoin
  describe PriceDataFetcher do
    let(:params) {{ start: '2018-08-01', end: '2018-08-08', currency: 'USD' }}
    let(:filterForm) { FilterForm.new(params) }
    let(:requestResults) { { bpi: 'value' }.to_json }
    subject { described_class.new(filterForm) }

    describe '#call' do
      it 'returns correct value' do
        allow(HTTP).to receive(:get).with(API_URL, { params: params }).and_return(requestResults)
        expect(subject.call).to eq('value')
      end
    end
  end
end
