class Dashboard::CoursesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_course_as_instructor!, only: [:show, :edit, :update, :share]

  include CoursesEditingConcern
  before_filter :prepare_steps, only: [:new, :edit, :create, :update]
  before_filter :update_steps_for_dashboard, only: [:edit, :update]

  def show
    @events = Event.grouped_by_date_and_type(course: @course)
  end

  def edit
  end

  def update
    if @course.update_attributes(course_params)
      redirect_to_next_step
      # redirect_to edit_dashboard_course_path(@course, :step => params[:step])
    else
      render :edit
    end
  end

  protected

  def redirect_to_next_step
    if next_step
      redirect_to edit_dashboard_course_path(@course, :step => next_step[:id])
    else
      redirect_to dashboard_course_path(@course)
    end
  end

  def update_steps_for_dashboard
    @steps = @steps.reject { |s| s[:id] == 'page' }
  end
end