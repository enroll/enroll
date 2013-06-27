class CoursesController < ApplicationController

  def new
    @course = Course.new
  end

  def index
    @courses = Course.all
  end

  def show
    @course = Course.find(params[:id])
  end

  def create
    @course = Course.new(course_params)
    if @course.save
      flash[:success] = "Course created successfully."
      redirect_to course_path(@course)
    else
      flash[:error] = "Course failed to be created."
      render :new
    end
  end

  private

  def course_params
    params.require(:course).permit(:name)
  end
end
