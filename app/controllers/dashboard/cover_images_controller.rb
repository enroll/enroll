class Dashboard::CoverImagesController < ApplicationController
  before_filter :find_course_as_instructor_by_course_id!, except: [:update]

  def create
    puts "Creating the cover image"

    image = CoverImage.new(cover_image_params)
    image.course = @course
    image.save!

    render json: image
  end

  def update
    image = CoverImage.find(params[:id])
    image.update_attributes!(params.require(:cover_image).permit(:offset_admin_px))
    render nothing: true
  end

  protected

  def cover_image_params
    params.require(:course).require(:cover_image).permit(:image)
  end
end