class Dashboard::CoursesController < ApplicationController
  before_filter :authenticate_user!

  def show
    add_body_class('dashboard')

    @course = current_user.courses_as_instructor.find(params[:id])
  end
end