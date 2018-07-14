# frozen_string_literal: true

class BitcoinController < ApplicationController
  def index
    @filter_form = Bitcoin::FilterForm.new(filter_form_params)
    bitcoin_raw_data = Bitcoin::PriceDataFetcher.new(@filter_form).call
    @bitcoin_price_data = Bitcoin::PriceDataProcessor.new(bitcoin_raw_data).call
  end

  private

  def filter_form_params
    params.fetch(:bitcoin_filter_form, {}).permit(:start, :end, :currency)
  end
end
