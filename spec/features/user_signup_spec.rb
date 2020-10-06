require "rails_helper"

RSpec.feature "user sign up", type: :feature do
  context "New user" do
    let(:user_data) {{ name: 'Bingley', email: 'bingley@netherfield.com', password: 'Jan3love', password_confirmation: 'Jan3love' }}

    scenario "Users fill form with valid information" do
      visit signup_path
      fill_in_sign_up_form user_data
      expect(page).to have_content('Bingley')
    end

    scenario "Email is empty" do
      user_data[:email] = " "
      visit signup_path
      fill_in_sign_up_form user_data
      then_i_should_see_error_message 'email.blank'
    end

    scenario "Email is invalid" do
      user_data[:email] = 'not a valid email'
      visit signup_path
      fill_in_sign_up_form user_data
      then_i_should_see_error_message 'email.invalid'
    end

    scenario "Email is taken" do
      create :bingley
      visit signup_path
      fill_in_sign_up_form user_data
      then_i_should_see_error_message 'email.taken'
    end

    scenario "Password is empty" do
      user_data[:password] = ""
      visit signup_path
      fill_in_sign_up_form user_data
      then_i_should_see_error_message 'password.blank'
    end

    scenario "Password is too short" do
      user_data[:password] = "12345"
      visit signup_path
      fill_in_sign_up_form user_data
      then_i_should_see_error_message 'password.too_short'
    end

    scenario "Confirmation password does not match" do
      user_data[:password_confirmation] = "12345678"
      visit signup_path
      fill_in_sign_up_form user_data
      then_i_should_see_error_message 'password_confirmation.confirmation'
    end
  end

  private

  def fill_in_sign_up_form(user)
    fill_in 'user_name',      with: user[:name]
    fill_in 'user_email'    , with: user[:email]
    fill_in 'user_password' , with: user[:password]
    fill_in 'user_password_confirmation', with: user[:password_confirmation]
    click_button 'Sign Up'
  end

  def then_i_should_see_error_message(message)
    expect(page).to have_content(I18n.t("activerecord.errors.models.user.attributes.#{message}"))
  end
end