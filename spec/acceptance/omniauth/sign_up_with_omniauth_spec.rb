require 'acceptance/acceptance_helper'

feature 'User sign up with omniauth', '
  In order to be able to sign in other social networks
  As a social network user
  I want to be able to sign up using my account in other social network
' do

  scenario 'twitter user signs up' do
    visit new_user_session_path
    click_on 'Sign in with Twitter2'
    mock_auth_hash
    fill_in 'Your email', with: 'real@email.org'
    click_on 'Update'
    open_email('real@email.org')
    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed.'
  end

  scenario 'github user signs up' do
    visit new_user_session_path
    click_on 'Sign in with GitHub'
    mock_auth_hash
    fill_in 'Your email', with: 'real@email.org'
    click_on 'Update'
    open_email('real@email.org')
    current_email.click_link 'Confirm my account'

    expect(page).to have_content 'Your email address has been successfully confirmed.'
  end
end
