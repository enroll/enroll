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

  it "generates token for each email" do
    MarketingToken.count.should == 0
    emails = "foo@example.com,bar@example.com\nbaz@example.com"
    post :create, email: {emails: emails, subject: 'bazinga', content: 'hello', sender: 'we@enroll.io'}

    MarketingToken.count.should == 3
    MarketingToken.all.to_a.collect(&:email).should == ['foo@example.com', 'bar@example.com', 'baz@example.com']
  end

  it "replaces mentions of enroll.io with the customized link" do
    emails = "foo@example.com"
    content = "Hello there, check out http://enroll.io !"
    post :create, email: {emails: emails, subject: 'bazinga', content: content, sender: 'we@enroll.io'} 

    token = MarketingToken.last.token
    mail_content = ActionMailer::Base.deliveries.last.body.raw_source.strip

    mail_content.should == 'Hello there, check out http://enroll.io/?i=%s !' % [token]
  end

  it "tracks the mixpanel event with the token's distinct_id" do
    SecureRandom.expects(:base64).returns('SOME_DISTINCT_ID')

    mixpanel = Mixpanel::Tracker.any_instance
    mixpanel.expects(:set).with('foo@example.com', {email: 'foo@example.com'})
    mixpanel.expects(:track).with('Initial Marketing Email', {distinct_id: 'SOME_DISTINCT_ID'})

    emails = "foo@example.com"
    content = "Hello there, check out http://enroll.io !"
    post :create, email: {emails: emails, subject: 'bazinga', content: content, sender: 'we@enroll.io', event: 'Initial Marketing Email'} 
  end

  it "ccs to ourselves" do
    emails = "foo@example.com"
    content = "Hello there, check out http://enroll.io !"
    post :create, email: {
      emails: emails,
      subject: 'bazinga',
      content: content,
      sender: 'we@enroll.io',
      cc_us: 1
    }

    ActionMailer::Base.deliveries.last.cc.should == ['support@enroll.io']
  end

  it "uses the same token for an existing email address" do
    emails = "foo@example.com"
    content = "Hello there, check out http://enroll.io !"
    post :create, email: {emails: emails, subject: 'bazinga', content: content, sender: 'we@enroll.io'} 
    post :create, email: {emails: emails, subject: 'bazinga', content: content, sender: 'we@enroll.io'} 

    MarketingToken.count.should == 1
  end

  it "allows to select mixpanel event" do
    SecureRandom.expects(:base64).returns('SOME_DISTINCT_ID')

    mixpanel = Mixpanel::Tracker.any_instance
    mixpanel.stubs(:set)
    mixpanel.expects(:track).with('AWESOME EVENT', {distinct_id: 'SOME_DISTINCT_ID'})

    emails = "foo@example.com"
    content = "Hello there, check out http://enroll.io !"
    post :create, email: {emails: emails, subject: 'bazinga', content: content, sender: 'we@enroll.io', event: 'AWESOME EVENT'} 
  end
end