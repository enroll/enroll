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
      @ga_tracking_id ||= ENV["GA_TRACKING_ID"]
    end
    attr_writer :ga_tracking_id

    # Google Analytics Domain
    def ga_domain
      @ga_domain ||= ENV["GA_DOMAIN"]
    end
    attr_writer :ga_domain

  end
end

