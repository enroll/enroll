module StylingHelper
  def course_text_style
    "color: #{@course.color}"
  end

  def course_background_style
    "background-color: #{@course.color}"
  end

  def logo_style(logo)
    if !logo.blank?
      "background-image: url(#{logo.url(:logo)}); background-size: auto; background-position: 0 0;"  
    end
    
  end
end