# frozen_string_literal: true
API_URL="https://api.coindesk.com/v1/bpi/historical/close.json"

module Bitcoin
  class PriceDataFetcher
    attr_reader :filter_form

    def initialize(filter_form)
      @filter_form = filter_form
    end

    def call
      result = fetchData
      JSON.parse(result.to_s)['bpi']
    end

    private

    def fetchData
      HTTP.get(API_URL, params: requestParams)
    end

    def requestParams
      {
        start: filter_form.start,
        end: filter_form.end,
        currency: filter_form.currency
      }
    end
  end
end
