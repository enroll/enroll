class CourseCreatedNotification
  @queue = :notifications

  def self.perform(id)
    course = Course.find(id)
    course.send_course_created_notification!
  end
end
