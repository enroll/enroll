class CoursesController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create, :edit, :update]
  before_filter :find_course_as_instructor!, only: [:edit, :update]
  before_filter :find_course_by_url!, only: [:show]
  before_filter :prepare_steps, only: [:new, :edit, :create, :update]

  STEPS = [
    {id: 'details', label: 'Details'},
    {id: 'dates_location', label: 'Dates & Location'},
    {id: 'pricing', label: 'Pricing'},
    {id: 'page', label: 'Landing page'}
  ]

  def index
    @courses = Course.all
  end

  def show
    add_body_class('landing-page')
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)
    @course.instructor = current_user
    @location = @course.location

    puts "saving course"

    if @course.save
      redirect_to_next_step
    else
      puts "Failed to save course"
      puts @course.errors.messages
      render :new
    end
  end

  def redirect_to_next_step
    if next_step
      redirect_to edit_course_path(@course, :step => next_step[:id])
    else
      redirect_to course_path(@course)
    end
  end

  def edit
    @course.set_default_values_if_nil
  end

  def update
    if @course.update_attributes(course_params)
      redirect_to_next_step
    else
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
  end

  helper_method :current_step
  def current_step
    @steps.find { |s| s[:id] == params[:step] } || @steps[0]
  end

  helper_method :next_step
  def next_step
    index = @steps.index(current_step)
    @steps[index + 1]
  end
end
