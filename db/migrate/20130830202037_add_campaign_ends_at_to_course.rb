class AddCampaignEndsAtToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :campaign_ends_at, :datetime
  end
end
