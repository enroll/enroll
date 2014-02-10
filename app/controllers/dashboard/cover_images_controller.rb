class Dashboard::CoverImagesController < ApplicationController
  def create
    puts "Creating the cover image"
    raise cover_image_params.inspect
  end

  protected

  def cover_image_params
    params.require(:course).require(:cover_image).permit(:file)
  end
end