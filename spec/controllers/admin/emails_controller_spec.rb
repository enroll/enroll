require "spec_helper"

describe Admin::EmailsController do
  before :each do
    request.env['HTTP_AUTHORIZATION'] =
      ActionController::HttpAuthentication::Basic.encode_credentials('enroll', 'coffee')
    ActionMailer::Base.deliveries = []
  end

  it "generates marketing token" do
    post :create, email: {emails: 'foo@example.com', content: 'hello', sender: 'we@enroll.io'}

    MarketingToken.last.tap do |token|
      token.should_not be_nil
      token.token.should_not be_nil
      token.token.length.should == 2
      token.distinct_id.should_not be_nil
      token.distinct_id.length.should > 10
    end
  end
  
  it "sends an email to every address" do
    emails = "foo@example.com,bar@example.com\nbaz@example.com"

    post :create, email: {emails: emails, subject: 'bazinga', content: 'hello', sender: 'we@enroll.io'}

    ActionMailer::Base.deliveries.tap do |deliveries|
      deliveries.count.should == 3
      deliveries[0].to.should == ['foo@example.com']
      deliveries[1].to.should == ['bar@example.com']
      deliveries[2].to.should == ['baz@example.com']
      deliveries.last.subject.should == 'bazinga'
      deliveries.last.body.raw_source.strip.should == 'hello'

      deliveries.last.from.should == ['we@enroll.io']
    end
  end
end