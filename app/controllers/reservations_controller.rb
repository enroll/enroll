class ReservationsController < ApplicationController
  before_filter :authenticate_user!, only: [:show]
  before_filter :require_course!

  def new
    @reservation = @course.reservations.build
    @user = current_user || User.new
  end

  def create
    @reservation = @course.reservations.build :stripe_token => params[:stripeToken]

    unless user_signed_in?
      @user = User.new(user_params)
      sign_in(@user) if @user.save
    end

    @reservation.student = current_user
    @reservation.save

    if user_signed_in? && @reservation.valid?
      Event.create_event(Event::STUDENT_ENROLLED, course: @course, user: current_user)
      flash[:success] = "Reservation created successfully."
      redirect_to course_reservation_path(@course, @reservation)
    else
      flash[:error] = "Reservation failed to be created."
      render :new
    end
  end

  def show
    @reservation = @course.reservations.find(params[:id])
    @student = @reservation.student
  end

  private

  def require_course!
    unless @course = Course.find(params[:course_id])
      flash[:error] = "Couldn't find the course you were looking for"
      return redirect_to root_url
    end
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
