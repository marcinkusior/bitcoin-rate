module Bitcoin
  describe PriceDataProcessor do
    let(:raw_data) {{ test: 'value' }.to_json}
    subject { described_class.new(raw_data) }

    describe '#call' do
      it 'returns correct value' do
        expect(subject.call).to eq("test value")
      end
    end
  end
end
