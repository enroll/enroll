desc "Check to see if any campaigns have failed"
task :fail_campaigns => :environment do
  Course.fail_campaigns
end
