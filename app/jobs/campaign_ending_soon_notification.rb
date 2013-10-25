class CampaignEndingSoonNotification
  @queue = :notifications

  def self.perform(id)
    course = Course.find(id)
    course.send_campaign_ending_soon_notifications!
  end
end
