class GenericMailer < ActionMailer::Base
  def generic_mail(options={})
    @content = options[:content]

    mail \
      to: options[:to],
      from: options[:from],
      subject: options[:subject]
  end
end
