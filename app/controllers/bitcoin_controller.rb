class BitcoinController < ApplicationController
  def index
    @filterForm = Bitcoin::FilterForm.new(filter_form_params)
    @bitcoin_price_data = Bitcoin::PriceDataFetcher.new(@filterForm).call
  end

  private

  def filter_form_params
    params.fetch(:bitcoin_filter_form, {}).permit(:start, :end, :currency)
  end
end
