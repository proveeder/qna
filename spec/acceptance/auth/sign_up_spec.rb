require 'rails_helper'

feature 'User sign up', '
  In order to be able to use full site functionality
  As a non-registered user
  I want to be able to sign up
' do

  scenario 'Not registered user signs up with valid data' do
    visit new_user_registration_path

    fill_in 'Email', with: 'valid@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Registered user signs up' do
    user = create(:user)

    visit new_user_registration_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end

  # Here can be too much very similar cases so I just got some of them together:
  # too short pswd, different pswds, invalid email
  scenario 'User tries to sign up with invalid data' do
    visit new_user_registration_path

    fill_in 'Email', with: 'wrong_email'
    fill_in 'Password', with: '`'
    fill_in 'Password confirmation', with: 'wrongPSWD'
    click_on 'Sign up'

    expect(current_path).to eq user_registration_path
  end
end


