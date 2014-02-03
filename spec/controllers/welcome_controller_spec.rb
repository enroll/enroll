require "spec_helper"

describe WelcomeController do
  let(:user) { create(:user) }

  describe "#index" do
    it "generates a visitor_id and stores it in a cookie" do
      get :index
      cookies[:visitor_id].should_not be_nil
      cookies[:visitor_id].length.should > 5
    end

    it "generates and stores visitor_id in current_user" do
      sign_in(user)

      get :index

      controller.send(:visitor_id).length.should > 10
    end

    it "stores visitor_id from cookie to user object" do
      cookies[:visitor_id] = "visitor1"
      sign_in(user)
      get :index
      user.reload.visitor_id.should == 'visitor1'
    end

    it "uses marketing token to get us a pre-generated cookie" do
      # Prepare the token
      token = MarketingToken.generate!(email: 'foo@bar.com')

      # Let's assume there already is a cookie
      cookies[:visitor_id] = "ugly old token"

      # Expect the welcome event to be tracked with the new token
      Mixpanel::Tracker.any_instance.expects(:track).with('Welcome Page', {distinct_id: token.distinct_id})

      get :index, i: token.token

      cookies[:visitor_id].should == token.distinct_id
    end
  end

  describe "#about" do
    it "responds with the about page" do
      get :about
      response.should be_ok
    end
  end
end