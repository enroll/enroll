class Student::CoursesController < ApplicationController
  before_filter :find_course_as_student_by_id!

  def show
    
  end
end