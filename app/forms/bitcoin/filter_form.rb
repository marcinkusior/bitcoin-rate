# frozen_string_literal: true
AVAILABLE_CURRENCIES = ['USD', 'EUR', 'PLN'].freeze

module Bitcoin
  class FilterForm
    include ActiveModel::Model
    attr_accessor :start, :end, :currency

    def self.available_currencies
      AVAILABLE_CURRENCIES
    end

    def initialize(attributes)
      super(attributes)

      self.start ||= (Date.today - 365).to_s
      self.end ||= Date.today.to_s
      self.currency ||= 'USD'
    end
  end
end
