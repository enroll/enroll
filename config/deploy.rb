set :application, 'enroll'
set :deploy_to, '/var/apps/enroll'
set :scm, :git
set :repo_url, 'git@github.com:enroll/enroll.git'
set :branch, fetch(:branch, 'master')
set :ssh_options, {forward_agent: true}
set :log_level, :debug
set :linked_files, %w{config/database.yml}
set :linked_dirs, ["tmp/pids", "log"]

require 'tinder'

# Resque
set :resque_environment_task, true

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
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
campfire = Tinder::Campfire.new 'launchwise', :token => 'd357c54f65cf0a68b0fa66a4f6d0552c1c5f2a86'
room = campfire.find_room_by_name 'Enroll'

namespace :campfire do
  task :started do
    room.speak "Deploy to #{fetch(:stage)} started!"
  end
  task :finished do
    room.speak "Deploy to #{fetch(:stage)} finished!"
  end
  task :reverted do
    room.speak "Deploy to #{fetch(:stage)} reverted!"
  end
end

after 'deploy:started', 'campfire:started'
after 'deploy:finished', 'campfire:finished'
after 'deploy:reverted', 'campfire:reverted'