require 'acceptance/acceptance_helper'

feature 'Change question rating', '
  In order to show my opinion about question content
  As an authenticated user
  I want to be able to change question rating
' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'vote for question', js: true do
    sign_in(user)
    visit question_path(question) # required for capybara to show question on index view
    visit questions_path

    expect(page).to have_content 'Rating: 0'
    click_on 'Like'

    expect(page).to have_content 'Rating: 1'
  end
end

