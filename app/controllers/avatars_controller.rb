class AvatarsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @user = current_user
  end

  def create
    @user = current_user
    avatar_params = params.require(:user).permit(:avatar)
    current_user.update_attributes(avatar_params)
    flash.now[:notice] = "Photo was updated."
    render 'new'
  end
end
