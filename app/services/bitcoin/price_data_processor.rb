module Bitcoin
  class PriceDataProcessor
    attr_reader :raw_data

    def initialize(raw_data)
      @raw_data = raw_data
    end

    def call
      data = JSON.parse(raw_data.to_s)['bpi']
      process_data(data)
    end

    private

    def process_data(data)
      dataArray = []
      data.each do |k, v|
        dataArray << { date: k, value: v }
      end
      dataArray
    end
  end
end
