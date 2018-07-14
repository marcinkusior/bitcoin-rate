# frozen_string_literal: true

require 'rails_helper'

describe 'Bitcoin chart page', :vcr do
  before(:all) { Timecop.freeze Time.new(2018, 7, 5) }
  after(:all) { Timecop.return }

  shared_examples 'page correctly rendered when response is successful' do
    scenario 'page has title' do
      expect(page).to have_text('Bitcoin Price Index')
    end

    scenario 'page does not have error message' do
      expect(page).to_not have_text('Data could not be retrieved from server')
    end

    scenario 'page has graph element' do
      expect(page).to have_selector('.price-data-chart')
    end
  end

  context 'with initial filters', type: :request do
    before { visit root_path }

    it_behaves_like 'page correctly rendered when response is successful'

    scenario 'page has form set correctly' do
      expect(page).to have_field('bitcoin_filter_form[start]', with: '2017-07-05')
      expect(page).to have_field('bitcoin_filter_form[end]', with: '2018-07-05')
      expect(page).to have_select('bitcoin_filter_form[currency]', selected: 'USD')
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

    it_behaves_like 'page correctly rendered when response is successful'

    scenario 'page has form set correctly' do
      expect(page).to have_field('bitcoin_filter_form[start]', with: '2017-01-01')
      expect(page).to have_field('bitcoin_filter_form[end]', with: '2017-03-08')
      expect(page).to have_select('bitcoin_filter_form[currency]', selected: 'EUR')
    end
  end

  context 'when API returns error', type: :request do
    let(:params) { { start: '2017-07-05', end: '2018-07-05', currency: 'USD' } }

    before do
      allow(HTTP).to receive(:get)
        .with(Bitcoin::PriceDataFetcher::API_URL, params: params)
        .and_return(double(status: 500))

      visit root_path
    end

    scenario 'page has title' do
      expect(page).to have_text('Bitcoin Price Index')
    end

    scenario 'page has error message' do
      expect(page).to have_text('Data could not be retrieved from server')
    end

    scenario 'page does not have graph element' do
      expect(page).to_not have_selector('.price-data-chart')
    end
  end
end
