# frozen_string_literal: true

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
      data_array = []
      data.each do |k, v|
        data_array << { date: k, value: v }
      end
      data_array
    end
  end
end
