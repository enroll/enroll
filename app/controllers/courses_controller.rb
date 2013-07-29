class CoursesController < ApplicationController
  before_filter :authenticate_user!, only: [:edit]
  before_filter :find_course!, only: [:edit]

  def index
    @courses = Course.all
  end

  def show
    @course = Course.find(params[:id])
  end

  def new
    @course = Course.new
    @course.build_location
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
    @course = Course.new
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

  def find_course!
    @course = current_user.courses_as_instructor.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end
end
