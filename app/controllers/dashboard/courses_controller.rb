class Dashboard::CoursesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_course_as_instructor!, only: [:show, :edit, :update, :share, :review, :publish, :destroy_logo]

  include CoursesEditingConcern
  before_filter :prepare_steps, only: [:new, :edit, :create, :update]
  before_filter :update_steps_for_dashboard, only: [:edit, :update]

  def new
    @course = Course.new
    render 'edit'
  end

  def create
    @course = Course.new
    @course.instructor = current_user
    create_update
  end

  def show
    if @course.draft?
      return redirect_to edit_dashboard_course_path(@course, step: 'details')
    end
    @events = Event.grouped_by_date_and_type(course: @course)
    mixpanel_track_event 'Dashboard'
  end

  def edit
    @course.set_default_values_if_nil
  end

  def update
    create_update
  end

  def publish
    unless @course.publish!
      flash[:error] = "Cannot publish course with date in the past"
    end
    redirect_to dashboard_course_path(@course, published: 1)
  end

  def destroy_logo
    @course.logo = nil
    @course.save!
    render nothing: true
  end

  protected

  def create_update
    # raise course_params.inspect
    if @course.update_attributes(course_params)
      respond_to do |format|
        format.html {
          if next_step
            redirect_to_next_step
          else
            redirect_to review_dashboard_course_path(@course)
          end    
        }
        format.json { render json: @course }
      end
      
    else
      render :edit
    end
  end

  def redirect_to_next_step
    if next_step
      redirect_to edit_dashboard_course_path(@course, :step => next_step[:id])
    else
      redirect_to dashboard_course_path(@course)
    end
  end

  def update_steps_for_dashboard
  end
end