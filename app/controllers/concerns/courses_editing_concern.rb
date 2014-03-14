module CoursesEditingConcern
  extend ActiveSupport::Concern

  STEPS = [
    {id: 'details', mixpanel_event: 'Edit Course Details'},
    {id: 'dates', mixpanel_event: 'Edit Course Dates'},
    {id: 'location', mixpanel_event: 'Edit Course Location'},
    {id: 'pricing', mixpanel_event: 'Edit Course Pricing'},
    {id: 'page', mixpanel_event: 'Edit Course Landing Page'}
  ]

  included do
    helper_method :current_step
    helper_method :current_step_mixpanel_event
    helper_method :next_step
  end

  def prepare_steps
    if !current_step
      redirect_to :step => 'details'
    end
  end

  
  def current_step
    @steps ||= STEPS
    step = @steps.find { |s| s[:id] == params[:step] }
    step
  end

  def current_step_mixpanel_event
    current_step[:mixpanel_event]
  end

  def next_step
    index = @steps.index(current_step)
    @steps[index + 1]
  end

  protected

  def course_params
    params.require(:course).permit(
      :name, :url, :tagline, :starts_at, :ends_at, :description,
      :instructor_biography, :min_seats, :max_seats, :price_per_seat_in_dollars,
      :color, :logo,
      location_attributes: [
        :name, :address, :address_2, :city, :state, :zip, :phone
      ],
      schedules_attributes: [
        :date, :starts_at, :ends_at
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

    if @course.logo && !@course.logo.blank?
      @logo = @course.logo
    end
  end
end