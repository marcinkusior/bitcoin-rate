# frozen_string_literal: true

module Bitcoin
  class PriceDataFetcher
    API_URL = 'https://api.coindesk.com/v1/bpi/historical/close.json'
    attr_reader :filter_form

    def initialize(filter_form)
      @filter_form = filter_form
    end

    def call
      HTTP.get(API_URL, params: request_params)
    end

    private

    def request_params
      {
        start: filter_form.start,
        end: filter_form.end,
        currency: filter_form.currency
      }
    end
  end
end
