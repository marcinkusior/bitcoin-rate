require 'rails_helper'

describe Bitcoin::PriceDataProcessor do
  let(:raw_data) {{ 'bpi': {'date1': 'value1', 'date2': 'value2'}}.to_json}
  subject { described_class.new(raw_data) }

  describe '#call' do
    it 'returns correct value' do
      expect(subject.call).to eq([{date: 'date1', value:'value1'}, {date: 'date2', value: 'value2'}])
    end
  end
end
