class AddCampaignFailedAtToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :campaign_failed_at, :datetime
  end
end
