require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Enroll
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.autoload_paths +=  %W( #{config.root}/lib
                                  #{config.root}/lib/paperclip_processors
                                  #{config.root}/app/jobs
                                  #{config.root}/app/presenters )
    
    config.assets.paths << "#{Rails.root}/app/assets/fonts"

    config.paperclip_defaults = {
      :storage => :s3,
      :s3_credentials => {
        :bucket => Enroll.s3_config["bucket"]["cover_images"],
        :access_key_id => Enroll.s3_config["access_key_id"],
        :secret_access_key => Enroll.s3_config["secret_access_key"]
      }
    }
  end
end
