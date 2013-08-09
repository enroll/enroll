module CourseHelper
  def reservations_needed(course)
    return "?" unless course.min_seats

    needed = course.min_seats - course.reservations.count
    needed > 0 ? needed : 0
  end

  def days_until_start(course)
    return "?" unless course.starts_at

    days_until = (course.starts_at.to_date - Date.today).numerator
    days_until > 0 ? days_until : 0
  end
end
