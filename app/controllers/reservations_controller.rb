class ReservationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_course!

  def new
    @reservation = @course.reservations.build
  end

  def create
    @reservation = @course.reservations.build
    @reservation.student = current_user

    if @reservation.save
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
end
