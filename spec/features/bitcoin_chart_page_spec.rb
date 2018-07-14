# frozen_string_literal: true

require 'rails_helper'

feature 'Bitcoin chart page' do
  context 'with initial filters', type: :request do
    let(:now) { Time.new(2018, 7, 5) }
    before { Timecop.freeze now }
    after  { Timecop.return }

    scenario 'page renders correctly' do
      visit root_path
      expect(page.body).to match_snapshot('initial_bitcoin_chart_page')
    end
  end

  context 'with filter set by user', type: :request do
    before do
      visit root_path

      within 'form#new_bitcoin_filter_form' do
        fill_in 'bitcoin_filter_form[start]', with: '2017-01-01'
        fill_in 'bitcoin_filter_form[end]', with: '2017-03-08'
        select('EUR', from: 'bitcoin_filter_form[currency]')
        click_on 'filter'
      end
    end

    scenario 'page renders correctly' do
      expect(page.body).to match_snapshot('bitcoin_chart_page_with_set_filters')
    end
  end
end
