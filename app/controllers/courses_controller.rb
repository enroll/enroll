class CoursesController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create, :edit, :update, :index]
  before_filter :find_course_as_instructor!, only: [:edit, :update]
  before_filter :find_course_by_url!, only: [:show, :preview]

  include CoursesEditingConcern
  before_filter :prepare_steps, only: [:new, :edit, :create, :update]
  before_filter :setup_markdown, only: [:show, :preview]

  def index
    @courses_teaching = current_user.courses_as_instructor
    @courses_studying = current_user.courses_as_student
  end

  def show
    @preview = false
    add_body_class('landing-page')
    Event.create_event(Event::PAGE_VISITED, course: @course)
    mixpanel_track_event 'Landing Page'
  end

  def preview
    @course.attributes = course_params
    @preview = true
    render 'show', layout: false
  end

  protected

  def setup_markdown
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true)
  end

  def redirect_to_next_step
    if next_step
      redirect_to edit_course_step_path(@course, :step => next_step[:id])
    else
      redirect_to dashboard_course_path(@course)
    end
  end

end
