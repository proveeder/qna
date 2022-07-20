require 'rails_helper'

feature 'Create question', '
  In order to receive answer from community
  As an authenticated user
  I want to be able to ask question
' do

  scenario 'Authenticated user creates question' do
    User.create!(email: 'user@test.com', password: '12345678')

    visit new_user_session_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test body'

    click_on 'Create'

    expect(page).to have_content 'Your question was created successfully'
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
