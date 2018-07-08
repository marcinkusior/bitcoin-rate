class BitcoinController < ApplicationController
  def index
    @filterForm = Bitcoin::FilterForm.new(filter_form_params)
  end

  private

  def filter_form_params
    params.fetch(:bitcoin_filter_form, {}).permit(:start_date, :end_date, :currency)
  end
end
