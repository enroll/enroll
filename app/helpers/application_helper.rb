module ApplicationHelper
  def course_reservation_link(course, options={})
    link_to 'Reserve your seat',
      new_course_reservation_path(course),
      :class => options[:class] ||= 'btn btn-primary btn-large reserve upcase'
  end

  def gravatar_for(email, options = {})
    options = {:alt => 'avatar', :class => 'img-rounded', :size => 30}.merge! options
    id = email.blank? ? "00000000000000000000000000000000" : Digest::MD5::hexdigest(email.strip.downcase)
    url = 'https://www.gravatar.com/avatar/' + id + '.jpg?s=' + options[:size].to_s + '&d=retro'
    options.delete :size
    image_tag url, options
  end
end
