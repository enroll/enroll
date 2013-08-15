# Sentry Exception Notification - http://getsentry.com
# https://github.com/getsentry/raven-ruby#sentry_dsn
require 'raven'

Raven.configure do |config|
  config.dsn = 'https://fc347a4866a644ccae1272881fed4ee0:9b6ac53cbe844c24bdb5c9f8399cebc8@app.getsentry.com/11923'
end
