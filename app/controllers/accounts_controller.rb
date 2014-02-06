class AccountsController < ApplicationController
  before_filter :authenticate_user!, except: [:restore]

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      flash[:success] = "Account updated successfully."
      redirect_to edit_account_path
    else
      flash.now[:error] = "Unable to update your user account. Sorry about that."
      render :edit
    end
  end

  def restore
    if request.post?
      email = params[:user][:email]
      user = User.where(email: email).first

      if user
        user.send_reset_password_instructions
        flash.now[:notice] = "Link was sent to your email #{email}"
      else
        flash.now[:error] = "Cannot find user with email #{email}"
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
