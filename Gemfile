source 'https://rubygems.org'

ruby '2.0.0'
#ruby-gemset=enroll

gem 'rails', '~> 4.0.0'

# Standard gems
gem 'coffee-rails',   '~> 4.0.0'
gem 'devise',         '~> 3.0.0'
gem 'haml',           '~> 4.0.3'
gem 'jbuilder',       '~> 1.0.1'
gem 'jquery-rails'
gem 'pg'
gem 'resque',         '1.24.1'
gem 'sass-rails',     '~> 4.0.0'
gem 'simple_form',    '~> 3.0.0.rc'
gem 'turbolinks'
gem 'unicorn'
gem 'uglifier',       '>= 1.3.0'
# ^- remember to keep this in alphabetical order

# Production gems that need further explanation:

# Try out bootstrap 3
gem 'anjlab-bootstrap-rails', github: 'anjlab/bootstrap-rails', branch: '3.0.0', require: 'bootstrap-rails'
gem 'bootstrap-glyphicons'

# Gems for Heroku
gem 'rails_log_stdout',           github: 'heroku/rails_log_stdout'
gem 'rails3_serve_static_assets', github: 'heroku/rails3_serve_static_assets'

group :development, :test do
  gem 'factory_girl_rails'
  gem 'mocha', '~> 0.13.3', :require => false
  gem 'rspec-instafail'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
end

group :development do
  gem 'foreman'
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'guard-shell'
end

