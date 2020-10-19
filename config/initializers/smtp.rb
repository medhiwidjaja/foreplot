ActionMailer::Base.smtp_settings = {
  address: Rails.application.credentials.smtp_address,
  port: 587,
  domain: Rails.application.credentials.smtp_domain,
  user_name: Rails.application.credentials.smtp_user_name,
  password: Rails.application.credentials.smtp_password,
  authentication: :login,
  enable_starttls_auto: true
}