source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '~> 4.0.0'

# Standard gems
gem 'angularjs-rails'
gem 'coffee-rails',   '~> 4.0.0'
gem 'devise',         '~> 3.0.1'
gem 'entypo-rails'
gem 'haml',           '~> 4.0.3'
gem 'jbuilder',       '~> 1.0.1'
gem 'jquery-rails'
gem 'mail_gate',      '1.1.2'
gem 'pg'
gem 'redcarpet'
gem 'resque',         '1.24.1'
gem 'sass-rails',     '~> 4.0.0'
gem 'sentry-raven',   '0.6.0'
gem 'simple_form',    '~> 3.0.0'
gem 'spine-rails'
gem 'spinjs-rails'
gem 'state_machine',  '1.2.0'
gem 'stringex'
gem 'stripe',         '1.8.3'
gem 'tilt-jade'
gem 'unicorn'
gem 'uglifier',       '>= 1.3.0'
# ^- remember to keep this in alphabetical order

# Production gems that need further explanation:

# Try out bootstrap 3
gem 'anjlab-bootstrap-rails', '>= 3.0.0.3', require: 'bootstrap-rails'
gem 'bootstrap-glyphicons'

group :development, :test do
  gem 'factory_girl_rails'
  gem 'mocha', '~> 0.13.3', require: false
  gem 'rspec-instafail'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'vcr'
  gem 'dotenv-rails'
  gem 'email_spec'
  gem 'timecop'
end

group :test do
  gem 'vcr'
  gem 'webmock'
end

group :development do
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'foreman'
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'guard-shell'
  gem 'pry-rails'
end

group :production, :staging do
  gem 'rails_12factor'
end
