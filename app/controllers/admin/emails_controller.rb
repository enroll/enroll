class Admin::EmailsController < ApplicationController
  http_basic_authenticate_with :name => "enroll", :password => "coffee"

  def index
    @tokens = MarketingToken.all
  end

  def new
    @available_events = ["Initial Marketing Email"]
  end

  def create
    emails = emails_from_text(params[:email][:emails])

    emails.each do |recipient|
      token = MarketingToken.where(email: recipient).first || \
        MarketingToken.generate!(email: recipient)

      content = params[:email][:content]
      content = self.add_token_to_content(content, token)
      
      options = {
        from: params[:email][:sender],
        to: recipient,
        subject: params[:email][:subject],
        content: content
      }

      options[:cc] = "support@enroll.io" if params[:email][:cc_us]

      GenericMailer.generic_mail(options).deliver!

      mixpanel.set(recipient, {email: recipient})
      mixpanel_track_event(params[:email][:event], {distinct_id: token.distinct_id})
    end

    flash[:notice] = "#{emails.length} emails were sent!"
    redirect_to new_admin_email_path
  end

  protected

  def emails_from_text(text)
    emails = text.split(/[\n,]+/)
    emails.reject! { |email|
      email == ","
    }
    emails.map! { |email|
      email.sub(/^.*<(.*?)>.*$/, '\1').strip
    }

    emails
  end

  def add_token_to_content(content, token)
    content.gsub 'http://enroll.io', \
      'http://enroll.io/?i=%s' % [token.token]
  end
end