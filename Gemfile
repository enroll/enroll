source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '~> 4.0.0'

# Standard gems
gem 'angularjs-rails'
gem 'coffee-rails',   '~> 4.0.0'
gem 'devise',         '~> 3.0.1'
gem 'haml',           '~> 4.0.3'
gem 'jbuilder',       '~> 1.0.1'
gem 'jquery-rails'
gem 'mail_gate',      '1.1.2'
gem 'pg'
gem 'resque',         '1.24.1'
gem 'sass-rails',     '~> 4.0.0'
gem 'sentry-raven',   '0.6.0'
gem 'simple_form',    github: 'plataformatec/simple_form'
gem 'stringex'
gem 'stripe'
gem 'turbolinks'
gem 'unicorn'
gem 'uglifier',       '>= 1.3.0'
# ^- remember to keep this in alphabetical order

# Production gems that need further explanation:

# Try out bootstrap 3
gem 'anjlab-bootstrap-rails', '>= 3.0.0.0', require: 'bootstrap-rails'
gem 'bootstrap-glyphicons'

group :development, :test do
  gem 'factory_girl_rails'
  gem 'mocha', '~> 0.13.3', require: false
  gem 'rspec-instafail'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'email_spec'
  gem 'timecop'
end

group :development do
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
