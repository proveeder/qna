require 'acceptance/acceptance_helper'

feature 'Create question', '
  In order to receive answer from community
  As an authenticated user
  I want to be able to ask question
' do

  given(:user) { create(:user) }

  context 'multiple sessions' do
    scenario 'question appears on another user\'s page', js: true do
      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        sign_in(user)
        create_question
        expect(page).to have_content 'Your question was created successfully'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'Test body'
      end

      Capybara.using_session('guest') do
        expect(page).to have_link 'Test question'
      end
    end
  end

  scenario 'Authenticated user creates question' do
    sign_in(user)
    create_question

    expect(page).to have_content 'Your question was created successfully'
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path

    expect(page).to_not have_link 'Ask question'
  end
end
