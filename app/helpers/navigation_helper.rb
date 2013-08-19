module NavigationHelper
  def nav_signupbox_class
    return nil if controller_name == "reservations"
    (@user && @user.errors.any?) || (@course && @course.errors.any?) ? 'in' : nil
  end

  def nav_loginbox_class
    flash.alert ? 'in' : nil
  end
end
