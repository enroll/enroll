class AddCampaignFailedToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :campaign_failed, :boolean, default: false
  end
end
