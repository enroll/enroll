# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/instafail'
require 'vcr'
require 'email_spec'
require 'vcr'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock # or :fakeweb
  c.default_cassette_options = { :record => :once }
  # c.allow_http_connections_when_no_cassette = true
  c.configure_rspec_metadata!
  c.debug_logger = File.open('log/vcr.log', 'w')
  c.ignore_hosts 'api.mixpanel.com'
  c.ignore_hosts 'enroll-test-cover-images.s3.amazonaws.com'
end

RSpec.configure do |config|
  config.mock_with :mocha
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.include FactoryGirl::Syntax::Methods

  # Authentication
  config.include Devise::TestHelpers, type: :controller

  # Aliases
  config.filter_run focused: true
  config.alias_example_to :fit, focused: true
  config.alias_example_to :pit, pending: true

  config.run_all_when_everything_filtered = true
  # config.render_views

  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers

  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.before(:suite) do
    Resque.inline = true
  end
end
