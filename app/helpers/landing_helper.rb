module LandingHelper
  def cover_image_style(course)
    return '' unless course.cover_image_object
    style = "background-image: url(#{course.cover_image(:main)}); "
    style += "background-position: center #{course.cover_image_object.offset_main_percent}%; "
    style
  end
end