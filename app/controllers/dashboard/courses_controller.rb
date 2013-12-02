class Dashboard::CoursesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_course_as_instructor!, only: [:show, :edit, :update, :share]

  include CoursesEditingConcern
  before_filter :prepare_steps, only: [:new, :edit, :create, :update]

  include GroupingHelper

  def show
    events = @course.events.order('created_at DESC')
    @events = group_list_by_date(events, :created_at)
  end

  def edit
    @steps = @steps.reject { |s| s[:id] == 'page' }
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
end