module CoursesEditingConcern
  extend ActiveSupport::Concern

  STEPS = [
    {id: 'details', label: 'Details'},
    {id: 'dates_location', label: 'Dates & Location'},
    {id: 'pricing', label: 'Pricing'},
    {id: 'page', label: 'Landing page'}
  ]

  included do
    helper_method :current_step
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
  end

  
  def next_step
    index = @steps.index(current_step)
    @steps[index + 1]
  end

  protected

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
end