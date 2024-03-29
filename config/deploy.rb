set :application, 'enroll'
set :deploy_to, '/var/apps/enroll'
set :scm, :git
set :repo_url, 'git@github.com:enroll/enroll.git'
set :branch, ENV['BRANCH'] || 'master'
set :ssh_options, {forward_agent: true}
set :log_level, :debug
set :linked_files, %w{config/database.yml}
set :linked_dirs, ["tmp/pids", "log", "public/system"]
set :test_log, "log/capistrano.test.log"

require 'tinder'

# Resque
set :resque_environment_task, true

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

  after 'deploy:restart', 'resque:restart'

end

# Campfire
campfire = Tinder::Campfire.new 'launchwise', :token => '42a2b525c7066a643cbf5ec448ee98728994923a'
room = campfire.find_room_by_name 'Enroll'

namespace :campfire do
  task :started do
    room.speak ":fire: Deploy #{fetch(:branch)} to #{fetch(:stage)} started!"
  end
  task :finished do
    room.speak ":fire: Deploy #{fetch(:branch)} to #{fetch(:stage)} finished!"
  end
  task :reverted do
    room.speak ":fire: Deploy #{fetch(:branch)} to #{fetch(:stage)} reverted!"
  end
end

# Tests
namespace :tests do
  task :run do
    puts "--> Running tests, please wait ..."
    system 'bundle exec kitty'
    test_log = fetch(:test_log)
    unless system "bundle exec rake > #{test_log} 2>&1" #' > /dev/null'
      puts "--> Tests failed. Run `cat #{test_log}` to see what went wrong."
      exit
    else      
      puts "--> Tests passed :-)"
      system "rm #{test_log}"
    end
  end
end

before 'deploy:starting', 'tests:run'

after 'deploy:started', 'campfire:started'
after 'deploy:finished', 'campfire:finished'
after 'deploy:reverted', 'campfire:reverted'

after 'deploy:publishing', 'deploy:restart'