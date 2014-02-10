class Dashboard::CoverImagesController < ApplicationController
  before_filter :find_course_as_instructor_by_course_id!

  def create
    puts "Creating the cover image"

    image = CoverImage.new(cover_image_params)
    image.course = @course
    image.save!

    raise image.inspect
  end

  protected

  def cover_image_params
    params.require(:course).require(:cover_image).permit(:image)
  end
end