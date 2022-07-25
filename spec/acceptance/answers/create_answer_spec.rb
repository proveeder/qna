require 'rails_helper'

feature 'Answer question', '
  In order to help people
  As an authenticated user
  I want to be able to answer question on the question page
' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  # still works good without any 'js: true' needed, didn't require any additional configuration
  scenario 'Authenticated user answer question with valid data', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Your answer', with: 'Some answer on question'
    click_on 'Add answer'

    within '.answers' do
      expect(page).to have_content 'Some answer on question'
    end
    expect(page).to have_content 'Thanks for your answer!'
  end

  scenario 'Authenticated user answer question with invalid data', js: true do
    sign_in(user)

    visit question_path(question)
    click_on 'Add answer'

    expect(page).to have_content 'You must enter text of your answer'
  end

  scenario 'Non-authenticated user try to answer question' do
    visit question_path(question)

    expect(page).not_to have_xpath('//form')
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end