# frozen_string_literal: true

class BitcoinController < ApplicationController
  def index
    flash[:error] = nil

    if price_data_fetcher.call
      price_data_processor.call
      @bitcoin_price_data = price_data_processor.data
    else
      flash[:error] = 'Data could not be retrieved from server'
    end
  end

  private

  def filter_form_params
    params.fetch(:bitcoin_filter_form, {}).permit(:start, :end, :currency)
  end

  def filter_form
    @filter_form ||= Bitcoin::FilterForm.new(filter_form_params)
  end

  def price_data_fetcher
    @price_data_fetcher ||= Bitcoin::PriceDataFetcher.new(filter_form)
  end

  def price_data_processor
    @price_data_processor ||= Bitcoin::PriceDataProcessor.new(price_data_fetcher.response)
  end
end
