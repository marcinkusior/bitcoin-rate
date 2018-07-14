# frozen_string_literal: true

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
ActiveRecord::Migration.maintain_test_schema!

require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = Rails.root.join('spec', 'fixtures', 'vcr_cassettes')
  c.hook_into :webmock
  c.default_cassette_options = { record: :once }
  c.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.snapshot_dir = 'spec/fixtures/snapshots'
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
