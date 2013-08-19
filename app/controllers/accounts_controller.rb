class AccountsController < ApplicationController
  before_filter :authenticate_user!

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      flash[:success] = "Account updated successfully."
      redirect_to edit_account_path
    else
      flash[:error] = "Unable to update your user account. Sorry about that."
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
