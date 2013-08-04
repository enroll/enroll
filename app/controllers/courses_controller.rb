class CoursesController < ApplicationController
  before_filter :authenticate_user!, only: [:edit, :update]
  before_filter :find_course!, only: [:edit, :update]

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
    @location = @course.location

    if @course.save
      flash[:success] = "Course created successfully."
      redirect_to course_path(@course)
    else
      flash[:error] = "Course failed to be created."
      render :new
    end
  end

  def edit
  end

  def update
    if @course.update_attributes(course_params)
      flash[:success] = "Course updated successfully."
      redirect_to edit_course_path(@course)
    else
      flash[:error] = "Course failed to be updated."
      render :edit
    end
  end

  private

  def course_params
    params.require(:course).permit(
      :name, :url, :tagline, :starts_at, :ends_at, :description,
      :instructor_biography, :min_seats, :max_seats, :price_per_seat_in_cents,
      location_attributes: [
        :name, :address, :address_2, :city, :state, :zip, :phone
      ]
    )
  end

  def find_course!
    @course = current_user.courses_as_instructor.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end
end
