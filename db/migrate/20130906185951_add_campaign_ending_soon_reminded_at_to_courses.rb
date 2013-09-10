class AddCampaignEndingSoonRemindedAtToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :campaign_ending_soon_reminded_at, :datetime
  end
end
