class EnrollmentNotification
  @queue = :notifications

  def self.perform(id)
    reservation = Reservation.find(id)
    reservation.send_enrollment_notification!
  end
end
