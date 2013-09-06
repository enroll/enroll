web: bin/unicorn -p $PORT -E $RACK_ENV
resque: env TERM_CHILD=1 bundle exec rake resque:work
