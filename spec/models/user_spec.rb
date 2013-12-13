require 'spec_helper'

describe User do
  let(:user) { build(:user) }

  it { should have_many(:reservations) }
  it { should have_many(:courses_as_student) }
  it { should have_many(:courses_as_instructor) }

  it { should validate_presence_of(:email) }

  describe '.courses' do
    before(:each) do
      user.save
      @instructor_course = create(:course, instructor: user)
      @student_course = create(:course)
      create(:reservation, student: user, course: @student_course)
    end

    it 'includes courses the user is taking as a student' do
      user.courses.should include(@student_course)
    end

    it 'includes courses that the user is teaching' do
      user.courses.should include(@instructor_course)
    end
  end

  describe '#display_title' do
    it 'is the same as the user email' do
      user.display_title.should == user.email
    end
  end

  describe "#staff?" do
    it 'returns true' do
      user.staff?.should be_true
    end
  end

  describe "#reservation_for_course" do
    it 'returns a reservation for the course if it exists' do
      user.save
      course = create(:course)
      reservation = create(:reservation, course: course, student: user)
      user.reservation_for_course(course).should == reservation
    end

    it 'returns nil if no reservation for the course exists' do
      course = create(:course)
      user.reservation_for_course(course).should == nil
    end
  end

  describe "#instructor?" do
    it 'returns true if user is teaching any courses' do
      user.save
      create(:course, instructor: user)
      user.should be_instructor
    end

    it 'returns true if user is teaching a course and attending a course' do
      user.save
      create(:course, instructor: user)
      create(:reservation, student: user)
      user.should be_instructor
    end

    it 'returns false if user is not teaching any courses' do
      user.save
      create(:reservation, student: user)
      user.should_not be_instructor
    end
  end

  describe "#student?" do
    it 'returns true if user is attending any courses' do
      user.save
      create(:reservation, student: user)
      user.should be_student
    end

    it 'returns true if user is attending a course and teaching a course' do
      user.save
      create(:reservation, student: user)
      create(:course, instructor: user)
      user.should be_student
    end

    it 'returns false if user is not attending any courses' do
      user.save
      create(:course, instructor: user)
      user.should_not be_student
    end
  end

  describe "#save_payment_settings!" do
    before { user.email = "someemail@example.com" }

    it 'create a Stripe recipient' do
      Stripe::Recipient.expects(:create).with({
        name: "John Doe",
        type: "individual",
        email: "someemail@example.com",
        bank_account: "abc123"
      })

      user.save_payment_settings!({
        name: "John Doe",
        stripe_bank_account_token: "abc123"
      })
    end

    it 'sets the stripe_recipient_id for the user' do
      Stripe::Recipient.stubs(:create).returns(stub(id: "some-recipient-id"))
      user.save_payment_settings!({
        name: "John Doe",
        stripe_bank_account_token: "abc123"
      })
      user.stripe_recipient_id.should == "some-recipient-id"
    end

    it 'sets the name for the user' do 
      Stripe::Recipient.stubs(:create).returns(stub(id: "some-recipient-id"))
      user.save_payment_settings!({
        name: "John Doe",
        email: "someemail@example.com"
      })
      user.name.should == "John Doe"
    end
  end

  describe "#update_stripe_customer" do
    context "existing stripe customer" do
      let :customer do
        customer = stub(deleted: false, id: 'cus1')
        customer.stubs(:card=)
        customer.stubs(:save)
        customer
      end

      before do
        user.stripe_customer_id = 'cus1'
        Stripe::Customer.stubs(:retrieve).with('cus1').returns(customer)
      end

      it "does NOT create a new customer" do
        Stripe::Customer.expects(:create).never
        user.update_stripe_customer('card1')
        user.stripe_customer_id.should == 'cus1'
      end

      it "changes card token" do
        customer.expects(:card=).with('card2')
        customer.expects(:save)

        user.update_stripe_customer('card2')
      end
    end
  end
end
