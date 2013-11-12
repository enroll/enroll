class CoursesController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create, :edit, :update]
  before_filter :find_course_as_instructor!, only: [:edit, :update]
  before_filter :find_course_by_url!, only: [:show]
  before_filter :prepare_steps, only: [:new]

  STEPS = [
    {id: 'details', label: 'Details'},
    {id: 'dates_location', label: 'Dates & Location'},
    {id: 'pricing', label: 'Pricing'},
    {id: 'page', label: 'Public Page'}
  ]

  def index
    @courses = Course.all
  end

  def show
  end

  def new
    @course = Course.new
    @course.min_seats = 5
    @course.max_seats = 15
    @course.price_per_seat_in_cents = 19900
    @course.build_location
  end

  def create
    @course = Course.new(course_params)
    @course.instructor = current_user
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

  def find_course_as_instructor!
    @course = current_user.courses_as_instructor.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def find_course_by_url!
    @course = if params[:url].present?
      Course.find_by!(url: params[:url])
    else
      Course.find(params[:id])
    end
  end

  def prepare_steps
    unless params[:step]
      redirect_to new_course_step_path(:step => 'details')
    end

    @steps = STEPS
    @current_step = params[:step]
  end
end
