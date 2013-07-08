# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

WorkshopPlatform::Application.load_tasks

unless Rails.env.production?
  Rake::TestTask.new(:spec) do |t|
    t.libs << 'spec'
    t.test_files = FileList['spec/**/*_spec.rb']
  end

  desc "Run tests"
  task :default => :spec
end
