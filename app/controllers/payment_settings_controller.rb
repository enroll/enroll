class PaymentSettingsController < ApplicationController
  before_filter :authenticate_user!

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.save_payment_settings!(stripe_recipient_params)
      flash[:success] = "Payment settings updated successfully."
      redirect_to edit_payment_settings_path
    else
      flash[:error] = "Unable to update your payment settings. Sorry about that."
      render :edit
    end
  end

  private

  def stripe_recipient_params
    params.require(:user).permit(:name, :stripe_bank_account_token)
  end
end
