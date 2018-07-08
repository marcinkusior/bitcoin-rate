# frozen_string_literal: true
AVAILABLE_CURRENCIES = ['USD', 'EUR', 'PLN'].freeze

module Bitcoin
  class FilterForm
    include ActiveModel::Model
    attr_accessor :start_date, :end_date, :currency

    def self.available_currencies
      AVAILABLE_CURRENCIES
    end

    def initialize(attributes)
      super(attributes)

      self.start_date ||= (Date.today - 30).to_s
      self.end_date ||= Date.today.to_s
      self.currency ||= 'USD'
    end
  end
end
