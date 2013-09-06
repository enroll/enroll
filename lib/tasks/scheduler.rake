desc "Check to see if any campaigns have failed"
task :fail_campaigns => :environment do
  Course.fail_campaigns
end

desc "Check to see if any campaigns are ending soon and have not met minimums"
task :ending_soon_campaigns => :environment do
  Course.notify_ending_soon_campaigns
end
