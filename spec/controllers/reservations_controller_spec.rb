require 'spec_helper'

describe ReservationsController do
  let(:user) { create(:user) }
  let(:course) { create(:course) }
  let(:reservation) { build(:reservation, course: course) }
  let(:reservation_attributes) { attributes_for(:reservation, course: course) }

  context "GET new" do
    it "renders the new page" do
      get :new, course_id: course.to_param
      response.should be_success
      response.should render_template :new
    end

    it "initializes a new reservation for a course" do
      get :new, course_id: course.to_param
      assigns[:course].should_not be_nil
      assigns[:reservation].should_not be_nil
    end
  end

  context "POST create" do
    context "with a user signed in" do
      it "creates a reservation for the current user" do
        sign_in user

        expect {
          post :create, course_id: course.to_param, reservation: reservation_attributes
        }.to change(user.reservations, :count)

        user.courses_as_student.last.should == course
      end
    end

    it "redirects to the reservation" do
      post :create, course_id: course.to_param, reservation: reservation_attributes
      response.should be_redirect
      response.should redirect_to(course_reservation_path(course, assigns[:reservation]))
    end

    it "sets the success flash" do
      post :create, course_id: course.to_param, reservation: reservation_attributes
      flash[:success].should_not be_nil
    end

    context "when submitting invalid data" do
      before { Reservation.any_instance.stubs(:save).returns(false) }

      it "renders the new page" do
        post :create, course_id: course.to_param, reservation: {}
        response.should render_template :new
      end

      it "sets the error flash" do
        post :create, course_id: course.to_param, reservation: {}
        flash[:error].should_not be_nil
      end
    end
  end

  context "GET show" do
    before { reservation.save }

    it "renders the show page" do
      get :show, course_id: course.to_param, id: reservation.to_param
      response.should be_success
      response.should render_template :show
    end
  end
end
