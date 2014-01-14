set :application, 'enroll'
set :deploy_to, '/var/apps/enroll'
set :scm, :git
set :repo_url, 'git@github.com:enroll/enroll.git'
set :ssh_options, {forward_agent: true}
set :log_level, :debug
set :linked_files, %w{config/database.yml}


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
