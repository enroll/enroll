class CampaignSuccessNotification
  @queue = :notifications

  def self.perform(id)
    course = Course.find(id)
    course.send_campaign_success_notifications!
  end
end
