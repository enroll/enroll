class Dashboard::ResourcesController < ApplicationController
  include Transloadit::Rails::ParamsDecoder

  before_filter :authenticate_user!
  before_filter :find_course_as_instructor_by_course_id!
  
  def index
    @resources = @course.resources
  end

  def new
    @resource = Resource.new 
  end

  def create
    @resource = Resource.new(resource_params)
    @resource.course = @course

    if !@resource.s3_url
      flash.now[:error] = "File upload failed"
      return render 'new'
    end

    if @resource.save
      redirect_to dashboard_course_resources_path(@course)
    else
      render 'new'
    end
  end

  protected

  def resource_params
    params.require(:resource).permit(:name, :description, :s3_url)
  end

end