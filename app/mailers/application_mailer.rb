class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.default_email_address
  layout 'mailer'
end
