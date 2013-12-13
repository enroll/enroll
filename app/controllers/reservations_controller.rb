class ReservationsController < ApplicationController
  before_filter :authenticate_user!, only: [:show]
  before_filter :require_course!

  def new
    add_body_class('landing-page')
    @reservation = @course.reservations.build
    @user = current_user || User.new
    if @user.enrolled_for?(@course)
      redirect_to landing_page_path(@course.url)
    end
  end

  def create
    add_body_class('landing-page')
    token = params[:reservation].try(:[], :stripe_token)

    # TODO: There's no point in storing Stripe token to reservation,
    # it will expire before we charge it. Stripe recommends using that
    # token to create a customer, and charge that customer later.
    # https://stripe.com/docs/tutorials/charges

    # We already have login in place that utilizes User#stripe_customer_id
    # to charge cards. (course.rb)

    # We're gonna create customer like they recommend below...

    @reservation = @course.reservations.build
    @user = current_user

    unless @user
      @user = User.new(user_params)
      if @user.save
        sign_in(@user)
      else
        return render :new
      end
    end

    @reservation.student = @user

    if @reservation.save
      @user.update_stripe_customer(token)

      Event.create_event(Event::STUDENT_ENROLLED, course: @course, user: current_user)
      redirect_to course_reservation_path(@course, @reservation)
    else
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
    params.require(:user).permit(:name, :email, :password)
  end
end
