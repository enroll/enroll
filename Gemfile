source 'https://rubygems.org'

ruby '2.0.0'

# Standard gems
gem 'coffee-rails', '~> 4.0.0'
gem 'jbuilder', '~> 1.0.1'
gem 'jquery-rails'
gem 'pg'
gem 'sass-rails', '~> 4.0.0.rc1'
gem 'turbolinks'
gem 'unicorn'
gem 'uglifier', '>= 1.3.0'
# ^- remember to keep this in alphabetical order

# Production gems that need further explanation:

# Try out bootstrap 3
gem 'anjlab-bootstrap-rails', github: 'anjlab/bootstrap-rails', branch: '3.0.0', require: 'bootstrap-rails'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', github: 'rails/rails', branch: '4-0-stable'

# Gems for Heroku
gem 'rails_log_stdout',           github: 'heroku/rails_log_stdout'
gem 'rails3_serve_static_assets', github: 'heroku/rails3_serve_static_assets'

group :development, :test do
  gem 'minitest-rails'
  gem 'capybara'
  gem 'turn'
  gem 'factory_girl_rails'
end

group :development do
  gem 'foreman'
  gem 'guard'
  gem 'guard-minitest'
  gem 'guard-shell'
  gem 'guard-bundler'
end

