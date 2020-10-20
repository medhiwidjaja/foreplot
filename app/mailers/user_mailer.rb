class UserMailer < Devise::Mailer
  default from: Rails.application.credentials.default_email_address
  default reply_to: Rails.application.credentials.default_email_address
  helper EmailHelper
  layout 'mailer'
end