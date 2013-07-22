class CoursesController < ApplicationController

  def new
    @course = Course.new
    @course.build_location
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
      @location = @course.location
      flash[:error] = "Course failed to be created."
      render :new
    end
  end

  def edit
    @course = Course.find(params[:id])
    render :layout => "manage_course"
  end

  private

  def course_params
    params.require(:course).permit(
      :name, :tagline, :course_starts_at, :course_ends_at, :description,
      location_attributes: [
        :name, :address, :city, :state, :zip, :phone
      ]
    )
  end
end
