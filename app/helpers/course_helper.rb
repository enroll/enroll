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

  def percentage_to_full(course)
    return 0 unless course.max_seats
    (course.reservations.count.to_f / course.max_seats) * 100
  end

  def percentage_goal(course)
    return 0 unless course.max_seats && course.min_seats
    (course.min_seats.to_f / course.max_seats) * 100
  end

  def course_reservation_link(course, options={})
    link_to 'Reserve your seat',
      new_course_reservation_path(course),
      :class => options[:class] ||= 'btn btn-primary btn-large reserve upcase'
  end
end
