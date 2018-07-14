# frozen_string_literal: true

module Bitcoin
  class PriceDataProcessor
    attr_reader :response, :data

    def initialize(response)
      @response = response
    end

    def call
      process_data
    end

    private

    def process_data
      data_array = []
      extract_data.each { |k, v| data_array << { date: k, value: v } }
      @data = data_array
    end

    def extract_data
      JSON.parse(response.to_s)['bpi']
    end
  end
end
