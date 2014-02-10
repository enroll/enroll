require 'spec_helper'

describe ReservationsController do
  let(:user) { create(:user) }
  let(:user_attributes) { attributes_for(:user) }
  let(:course) { create(:course) }
  let(:reservation) { build(:reservation, course: course) }
  let(:reservation_attributes) { attributes_for(:reservation, course: course) }
  let(:user_attributes) { attributes_for(:user) }

  before do
    sign_in user
    create(:schedule, course: course)
  end

  context "GET new" do
    render_views

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

    it "redirects to show if already enrolled" do
      create(:reservation, course: course, student: user)
      get :new, course_id: course.to_param
      response.should redirect_to landing_page_path(course.url)
    end
  end

  context "POST create" do
    let :customer do
      customer = stub(id: '123')
      customer.stubs(:card=)
      customer.stubs(:save)
      customer
    end

    before do
      Stripe::Customer.stubs(:create).returns(customer)
    end

    context "when course is paid" do
      it "creates customer with card token and saves customer token" do
        Stripe::Customer.expects(:create)
          .with(card: 'aaa', description: user.email)
          .returns(customer)
        post :create,
          course_id: course.to_param,
          reservation: reservation_attributes.merge(stripe_token: 'aaa')

        user.reload.stripe_customer_id.should == '123'
      end
    end

    context "with an existing user" do
      it "creates a reservation for the current user" do
        expect {
          post :create, course_id: course.to_param, reservation: reservation_attributes
        }.to change(user.reservations, :count)

        user.courses_as_student.last.should == course
      end

      it "redirects to the reservation" do
        post :create, course_id: course.to_param, reservation: reservation_attributes
        response.should redirect_to(course_reservation_path(course, assigns[:reservation]))
      end

      it "creates an event about reservation" do
        post :create, course_id: course.to_param, reservation: reservation_attributes
        Event.last.tap { |e|
          e.event_type.should == Event::STUDENT_ENROLLED
          e.user.should == user
          e.course.should == course
        }
      end
    end

    context "with a new user" do
      before(:each) do
        sign_out :user
      end

      it "creates a new user account" do
        expect {
          post :create, course_id: course.to_param, reservation: reservation_attributes, user: user_attributes
        }.to change(User, :count)
      end

      it "creates a reservation for the new user" do
        expect {
          post :create, course_id: course.to_param, reservation: reservation_attributes, user: user_attributes
        }.to change(course.reservations, :count)

        User.last.reservations.count.should == 1
        User.last.reservations.last.course.should == course
      end

      it "signs in the new user" do
        post :create, course_id: course.to_param, reservation: reservation_attributes, user: user_attributes
        warden.authenticated?(:user).should == true
      end

      it "requires an email and password" do
        post :create, course_id: course.to_param, user: { email: '', password: '' }
        assigns(:user).errors.messages.should_not be_empty
      end
    end

    context "when submitting invalid data" do
      before do
        Reservation.any_instance.stubs(:save).returns(false)
        Reservation.any_instance.stubs(:valid?).returns(false)
      end

      it "renders the new page" do
        post :create, course_id: course.to_param, reservation: {}
        response.should render_template :new
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
