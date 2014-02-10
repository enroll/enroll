class Student::ResourcesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_course_as_student_by_course_id!

  def index
    @resources = @course.resources
  end
end