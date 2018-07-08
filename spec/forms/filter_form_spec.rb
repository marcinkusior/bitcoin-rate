# frozen_string_literal: true

module Bitcoin
  describe FilterForm do
    subject { described_class }

    it '::available_currencies returns correct currencies' do
      expect(subject.available_currencies).to eq ['USD', 'EUR', 'PLN']
    end

    describe 'initialization' do
      subject { described_class.new(attributes) }
      let(:now) { Time.new(2018, 7, 8) }

      before { Timecop.freeze now }
      after  { Timecop.return }

      context 'when there are no attributes' do
        let(:attributes) { {} }

        it 'assigns default values' do
          expect(subject.end_date).to eq '2018-07-08'
          expect(subject.start_date).to eq '2018-06-08'
          expect(subject.currency).to eq 'USD'
        end
      end

      context 'when attributes are present' do
        let(:attributes) { { start_date: '2018-01-09', end_date: '2018-03-09', currency: 'EUR' } }

        it 'assigns attributes from passed params' do
          expect(subject.start_date).to eq '2018-01-09'
          expect(subject.end_date).to eq '2018-03-09'
          expect(subject.currency).to eq 'EUR'
        end
      end
    end
  end
end
