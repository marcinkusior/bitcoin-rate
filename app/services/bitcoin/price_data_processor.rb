module Bitcoin
  class PriceDataProcessor
    attr_reader :raw_data

    def initialize(raw_data)
      @raw_data = raw_data
    end

    def call
      JSON.parse(raw_data.to_s)["bpi"]
    end
  end
end
