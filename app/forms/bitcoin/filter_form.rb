# frozen_string_literal: true

module Bitcoin
  class FilterForm
    include ActiveModel::Model

    AVAILABLE_CURRENCIES = %w[USD EUR PLN].freeze
    attr_accessor :start, :end, :currency

    def initialize(attributes)
      super

      @start ||= (Date.today - 365).to_s
      @end ||= Date.today.to_s
      @currency ||= 'USD'
    end
  end
end
