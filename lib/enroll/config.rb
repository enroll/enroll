module Enroll
  module Config

    # Where to find the Redis server.
    #
    # We use RedisToGo in production on Heroku.
    def redis_url
      @redis_url ||= ENV["REDISTOGO_URL"] || ENV['GH_REDIS_URL'] || ENV['REDIS_URL'] || 'redis://127.0.0.1:6379/'
    end
    attr_writer :redis_url

    # The Redis client.
    def redis
      @redis ||= begin
        uri = URI.parse(redis_url)
        Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
      end
    end
    attr_writer :redis

    # Google Analytics Tracking Code
    def ga_tracking_id
      @ga_config ||= YAML.load_file(Rails.root.join('config', 'ga.yml').to_s)[Rails.env]
      @ga_tracking_id ||= @ga_config["tracking_id"]
    end
    attr_writer :ga_tracking_id

    # Google Analytics Domain
    def ga_domain
      @ga_config ||= YAML.load_file(Rails.root.join('config', 'ga.yml').to_s)[Rails.env]
      @ga_domain ||= @ga_config["domain"]
    end
    attr_writer :ga_domain

    # MixPanel
    def mixpanel_token
      @mixpanel_config ||= YAML.load_file(Rails.root.join('config', 'mixpanel.yml').to_s)[Rails.env]
      @mixpanel_token ||= @mixpanel_config["token"]      
    end

    # Amazon S3
    def s3_config
      @s3_config ||= YAML.load_file(Rails.root.join('config', 's3.yml').to_s)[Rails.env]
    end
  end
end

