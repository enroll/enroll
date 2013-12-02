class CoursesController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create, :edit, :update]
  before_filter :find_course_as_instructor!, only: [:edit, :update]
  before_filter :find_course_by_url!, only: [:show]

  include CoursesEditingConcern
  before_filter :prepare_steps, only: [:new, :edit, :create, :update]

  def index
    @courses_teaching = current_user.courses_as_instructor.future
    @courses_studying = current_user.courses_as_student
  end

  def show
    add_body_class('landing-page')
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true)
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

  def redirect_to_next_step
    if next_step
      redirect_to edit_course_step_path(@course, :step => next_step[:id])
    else
      redirect_to course_path(@course)
    end
  end

  def edit
    @course.set_default_values_if_nil
  end

  def update
    saved = @course.update_attributes(course_params)
    return render :edit unless saved

    if next_step
      redirect_to_next_step
    else
      event = Event.new
      event.event_type = Event::COURSE_CREATED
      event.course = @course
      event.save!
      redirect_to course_path(@course)
    end
  end

end
