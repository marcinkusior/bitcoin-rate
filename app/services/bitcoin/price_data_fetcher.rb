# frozen_string_literal: true
API_URL="https://api.coindesk.com/v1/bpi/historical/close.json"

module Bitcoin
  class PriceDataFetcher
    attr_reader :filter_form

    def initialize(filter_form)
      @filter_form = filter_form
    end

    def call
      HTTP.get(API_URL, params: requestParams)
    end

    private

    def requestParams
      {
        start: filter_form.start,
        end: filter_form.end,
        currency: filter_form.currency
      }
    end
  end
end
