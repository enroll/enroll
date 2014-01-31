require "spec_helper"

describe WelcomeController do
  let(:user) { create(:user) }

  before do
    Mixpanel::Tracker.any_instance.stubs(:track)
    Mixpanel::Tracker.any_instance.stubs(:set)
  end

  describe "#index" do
    it "generates a visitor_id and stores it in a cookie" do
      get :index
      cookies[:visitor_id].should_not be_nil
      cookies[:visitor_id].length.should > 5
    end 

    it "stores visitor_id from cookie to user object" do
      cookies[:visitor_id] = "visitor1"
      sign_in(user)
      get :index
      user.reload.visitor_id.should == 'visitor1'
    end
  end
end