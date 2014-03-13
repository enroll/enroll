require 'spec_helper'

describe AccountsController do
  let(:user) { create(:user) }

  describe 'GET edit' do
    before(:each) do
      sign_in user
    end

    it 'renders the edit page' do
      get :edit
      response.should be_success
      response.should render_template('edit')
    end

    it 'edits the current user' do
      get :edit
      assigns[:user].should == user
    end

    context 'when not logged in' do
      before(:each) do
        sign_out user
      end

      it 'redirects the user to the login page' do
        get :edit
        response.should be_redirect
        response.should redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PUT update' do
    context 'when successful' do
      before(:each) do
        sign_in user
        put :update, user: { email: 'updatedemail@example.com', name: 'Johnny Boy' }
      end

      it 'updates the current user email' do
        user.reload.email.should == 'updatedemail@example.com'
      end

      it 'updates the current user name' do
        user.reload.name.should == 'Johnny Boy'
      end

      it 'redirects to the edit page' do
        response.should be_redirect
        response.should redirect_to(edit_account_path)
      end

      it 'displays a success message' do
        flash[:success].should_not be_blank
      end
    end

    context 'when unsuccessful' do
      before(:each) do
        sign_in user
        User.any_instance.stubs(:update_attributes).returns(false)
        put :update, user: { email: 'updatedemail@example.com' }
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
        put :update, user: { email: 'updatedemail@example.com' }
        response.should be_redirect
        response.should redirect_to(new_user_session_path)
      end
    end
  end
end
