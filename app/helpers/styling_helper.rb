module StylingHelper
  def course_text_style
    "color: #{@course.color}"
  end

  def course_background_style
    "background-color: #{@course.color}"
  end
end