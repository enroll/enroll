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
    
    if @resource.file? && !handle_transloadit_upload
      flash.now[:error] = "File upload failed"
      return render 'new'
    end

    if @resource.save
      flash[:notice] = "Resource was added"
      redirect_to dashboard_course_resources_path(@course)
    else
      render 'new'
    end
  end

  def destroy
    resource = @course.resources.find(params[:id])
    resource.delete

    flash[:notice] = "Resource was deleted"
    redirect_to dashboard_course_resources_path(@course)
  end

  protected

  def resource_params
    params.require(:resource).permit(:name, :description, :s3_url, :resource_type, :link)
  end

  def transloadit_response
    params[:transloadit]
  end

  def handle_transloadit_upload
    unless transloadit_response && transloadit_response[:ok] && !transloadit_response[:results].empty?
      return false
    end

    @resource.s3_url = transloadit_response[:results][":original"].first[:url]
    @resource.transloadit_assembly_id = transloadit_response[:assembly_id]

    true
  end

end