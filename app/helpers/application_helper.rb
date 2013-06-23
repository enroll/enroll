module ApplicationHelper
  def course_reservation_link(course, options={})
    link_to 'Reserve your seat',
      new_course_reservation_path(course),
      :class => options[:class] ||= 'btn btn-primary btn-large reserve upcase'
  end
end
