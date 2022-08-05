require 'acceptance/acceptance_helper'

feature 'Create comment', '
  In order to participate in discussion
  As an authenticated user
  I want to be able to leave comments
' do

  given(:answer) { create(:answer) }

  context 'Authenticated user', js: true do
    context 'Leave comment for question' do
      scenario 'one session' do
        sign_in(answer.user)
        visit question_path(answer.question)

        within '.question' do
          fill_in 'Text', with: 'Test comment text'
          click_on 'Create comment'
          expect(page).to have_content 'Test comment text'
        end
      end

      scenario 'multiple sessions' do
        Capybara.using_session('guest') do
          visit question_path(answer.question)
        end

        Capybara.using_session('user') do
          sign_in(answer.user)
          visit question_path(answer.question)

          within '.question' do
            fill_in 'Text', with: 'Test comment text'
            click_on 'Create comment'
            expect(page).to have_content 'Test comment text'
          end
        end

        Capybara.using_session('guest') do
          expect(page).to have_content 'Test comment text'
        end
      end
    end

    context 'Leave comment for answer'
  end

  context 'Unauthenticated user', js: true do
    scenario 'Guest can\'t leave comments' do
      visit question_path(answer.question)

      expect(page).not_to have_link 'Create comment'
    end
  end
end
