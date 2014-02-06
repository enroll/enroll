class Dashboard::PaymentSettingsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_course_as_instructor_by_course_id!, only: [:edit, :update]

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.save_payment_settings!(stripe_recipient_params)
      flash[:success] = "Payment settings updated successfully."
      redirect_to edit_dashboard_course_payment_settings_path(@course.id)
    else
      flash.now[:error] = "Unable to update your payment settings. Sorry about that."
      render :edit
    end
  end

  private

  def stripe_recipient_params
    params.require(:user).permit(:name, :stripe_bank_account_token)
  end

  def find_course_as_instructor_by_course_id!
    @course = current_user.courses_as_instructor.find(params[:course_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end
end
