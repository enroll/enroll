class CoursesController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create, :edit, :update]
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
    mixpanel_track_event 'Landing page'
  end

  def preview
    @course.attributes = course_params
    @preview = true
    render 'show', layout: false
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)
    @course.instructor = current_user
    @location = @course.location

    if @course.save
      redirect_to_next_step
    else
      render :new
    end
  end

  def edit
    @course.set_default_values_if_nil
  end

  def update
    saved = @course.update_attributes!(course_params)
    return render :edit unless saved

    mixpanel_track_event "Course Creation #{current_step[:label]}"

    if next_step
      redirect_to_next_step
    else
      Event.create_event(Event::COURSE_CREATED, course: @course)
      redirect_to course_path(@course)
    end
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
