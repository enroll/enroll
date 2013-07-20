class Instructors::RegistrationsController < Devise::RegistrationsController

  def create
    @instructor = Instructor.new(instructor_params)
    @course = Course.new(course_params)
    @course.instructor = @instructor

    if @course.save
      sign_up(:instructor, @instructor)
      respond_with @instructor, :location => after_sign_up_path_for(@instructor)
    else
      flash.now[:error] = "Something went wrong."
      clean_up_passwords @instructor
      render :template => "welcome/index"
    end
  end

  def instructor_params
    params.require(:instructor).permit(:username, :email, :password, :salt, :encrypted_password)
  end

  def course_params
    params.require(:instructor).require(:course).permit(:name)
  end

  def after_sign_up_path_for(instructor)
    edit_course_path(instructor.courses.last)
  end
end
