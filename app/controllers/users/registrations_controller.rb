class Users::RegistrationsController < Devise::RegistrationsController
  def new
    @user = User.new
    @course = Course.new
  end

  def create
    @user = User.new(user_params)
    @course = Course.new(course_params)
    @course.instructor = @user

    if @course.save
      sign_up(:user, @user)
      mixpanel_track_event 'Sign Up'
      respond_with @user, location: after_sign_up_path_for(@user)
    else
      clean_up_passwords @user
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :salt, :encrypted_password)
  end

  def course_params
    params.require(:user).require(:course).permit(:name)
  end

  def after_sign_up_path_for(user)
    edit_dashboard_course_path(user.courses.last)
  end
end
