class Dashboard::StudentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_course!

  def find_course!
    @course = current_user.courses_as_instructor.find(params[:course_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to new_user_session_path
  end
end
