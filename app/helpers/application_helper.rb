module ApplicationHelper
  def course_reservation_link(course)
    link_to 'Reserve your seat',
      new_course_reservation_path(course),
      :class => 'btn btn-primary btn-large reserve upcase'
  end
end
