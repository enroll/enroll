source 'https://rubygems.org'
source 'http://gems.github.com'

ruby '2.0.0'

gem 'rails', '~> 4.0.0'

# Standard gems
gem 'angularjs-rails'
gem 'aws-sdk'
gem 'coffee-rails',   '~> 4.0.0'
gem 'devise',         '~> 3.0.1'
gem 'dotenv-rails'
gem 'entypo-rails'
gem 'faraday', '0.8.8'
gem 'haml',           '~> 4.0.3'
gem 'icalendar'
gem 'jbuilder',       '~> 1.0.1'
gem 'jquery-rails'
gem 'less'
gem 'mail_gate',      '1.1.2'
gem 'mixpanel'
gem 'paperclip' #,      '2.4.5'
gem 'pg'
gem 'redcarpet'
gem 'resque',         '1.24.1'
gem 'retina_tag'
gem 'sass-rails',     '~> 4.0.0'
gem 'sentry-raven',   '0.6.0'
gem 'simple_form',    '~> 3.0.0'
gem 'spinjs-rails'
gem 'state_machine',  '1.2.0'
gem 'stringex'
gem 'stripe',         '1.8.3'
gem 'therubyracer'
gem 'tilt-jade'
gem 'transloadit-rails', '1.1.1'
gem 'unicorn'
gem 'uglifier',       '>= 1.3.0'
# ^- remember to keep this in alphabetical order

# Production gems that need further explanation:

# Try out bootstrap 3
gem 'bootstrap-sass', '~> 3.1.0'

group :development, :test do
  gem 'factory_girl_rails'
  gem 'mocha', '~> 0.13.3', require: false
  gem 'rspec-instafail'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'vcr'
  gem 'email_spec'
  gem 'timecop'

  gem 'phantomjs'
  gem 'teaspoon'
  gem 'kitty'
end

group :test do
  gem 'webmock'
end

group :development do
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-resque', git: 'https://github.com/sshingler/capistrano-resque.git', require: false
  gem 'capistrano-bundler'
  gem 'foreman'
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'guard-shell'
  gem 'letter_opener'
  gem 'pry-rails'
  gem 'tinder', '1.9.3'
end

group :production, :staging do
  gem 'rails_12factor'
end
