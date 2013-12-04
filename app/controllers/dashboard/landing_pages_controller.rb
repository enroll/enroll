class Dashboard::LandingPagesController < ApplicationController
  include CoursesEditingConcern
  before_filter :find_course_as_instructor!, only: [:edit, :update]

  def edit
    
  end

  def update
    if @course.update_attributes(course_params)
      redirect_to edit_dashboard_landing_page_path(@course)
    else
      render 'edit'
    end
  end
end