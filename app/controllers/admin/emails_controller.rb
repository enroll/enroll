class Admin::EmailsController < ApplicationController
  http_basic_authenticate_with :name => "enroll", :password => "coffee"

  def new
    
  end

  def create
    emails = emails_from_text(params[:email][:emails])

    emails.each do |recipient|
      token = MarketingToken.generate!
      
      GenericMailer.generic_mail(
        from: params[:email][:sender],
        to: recipient,
        subject: params[:email][:subject],
        content: params[:email][:content]
      ).deliver!
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
end