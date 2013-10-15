module NavigationHelper
  def nav_signupbox_class
    return nil if controller_name == "reservations"
    (@user && @user.errors.any?) || (@course && @course.errors.any?) ? 'in' : nil
  end

  def nav_loginbox_class
    flash.alert ? 'in' : nil
  end

  def course_short_url(course)
    if course.url.nil?
      course_path(course)
    else
      '/go/' + course.url
    end
  end
end
