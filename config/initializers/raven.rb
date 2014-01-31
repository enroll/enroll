# Sentry Exception Notification - http://getsentry.com
# https://github.com/getsentry/raven-ruby#sentry_dsn
require 'raven'

Raven.configure do |config|
  config.dsn = 'https://6c21ec5fb70840c38a199d35facedc4d:3aa2984b908947deaa496fd998842734@app.getsentry.com/18653'
end
