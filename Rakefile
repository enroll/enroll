# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'resque/tasks'

Enroll::Application.load_tasks

task "resque:preload" => :environment

task "resque:setup" do
  ENV['QUEUE'] = '*'
end

# Rake::Task['default'].prerequisites.clear
# Rake::Task['default'].clear

task default: [:spec, :teaspoon]