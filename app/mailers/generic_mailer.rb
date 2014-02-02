class GenericMailer < ActionMailer::Base
  def generic_mail(options={})
    @content = options[:content]

    mail_options = {
      to: options[:to],
      from: options[:from],
      subject: options[:subject]
    }

    mail_options[:cc] = options[:cc] if options[:cc]

    mail mail_options
  end
end
