require 'rails_helper'

feature 'User sign out', '
  In order to be able to end my session
  As a signed-in user
  I want to be able to sign out
' do

  given(:user) { create(:user) }

  scenario 'Signed-in user try to sign out' do
    sign_in(user)
    sign_out
    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Not signed-in user try to sign out' do
    visit root_path
    expect(page).not_to have_css('#sign-out')
  end
end
