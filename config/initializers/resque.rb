require 'enroll'
require 'resque/server'

Resque.redis  = Enroll.redis
Resque.inline = Rails.env.development?

Resque::Server.use AuthenticatedRack
