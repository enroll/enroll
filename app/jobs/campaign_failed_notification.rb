class CampaignFailedNotification
  @queue = :notifications

  def self.perform(id)
    course = Course.find(id)
    course.send_campaign_failed_notifications!
  end
end
