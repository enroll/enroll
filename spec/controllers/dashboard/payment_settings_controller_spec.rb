require 'spec_helper'

describe Dashboard::PaymentSettingsController do
  let(:user) { create(:user) }
  let(:course) { create(:course, instructor: user) }

  describe 'GET edit' do
    before(:each) do
      sign_in user
    end

    it 'renders the edit page' do
      get :edit, course_id: course.id
      response.should be_success
      response.should render_template('edit')
    end

    it 'edits the current user' do
      get :edit, course_id: course.id
      assigns[:user].should == user
    end

    context 'when not logged in' do
      before(:each) do
        sign_out user
      end

      it 'redirects the user to the login page' do
        get :edit, course_id: course.id
        response.should be_redirect
        response.should redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PUT update' do
    context 'when successful' do
      before(:each) do
        sign_in user

        User.any_instance.stubs(:save_payment_settings!).returns(true)
      end

      it 'save the payment settings for the user' do
        User.any_instance.expects(:save_payment_settings!).with({ 
          'name' => 'Joe Full Legal Name',
          'stripe_bank_account_token' => 'tok_u5dg20Gra'
        })

        put :update, course_id: course.id, user: payment_settings_params
      end

      it 'redirects to the edit page' do
        put :update, course_id: course.id, user: payment_settings_params

        response.should be_redirect
        response.should redirect_to(edit_dashboard_course_payment_settings_path(course))
      end

      it 'displays a success message' do
        put :update, course_id: course.id, user: payment_settings_params
        flash[:success].should_not be_blank
      end
    end

    context 'when unsuccessful' do
      before(:each) do
        sign_in user
        User.any_instance.stubs(:save_payment_settings!).returns(false)
        put :update, course_id: course.id, user: payment_settings_params
      end

      it 're-renders the form' do
        response.should render_template('edit')
      end

      it 'displays an error message' do
        flash[:error].should_not be_blank
      end
    end

    context 'when not logged in' do
      it 'redirects the user to the login page' do
        put :update, course_id: course.id, user: payment_settings_params
        response.should be_redirect
        response.should redirect_to(new_user_session_path)
      end
    end
  end
end

def payment_settings_params
  { 
    'name' => 'Joe Full Legal Name',
    'stripe_bank_account_token' => 'tok_u5dg20Gra'
  }
end
