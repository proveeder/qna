require 'acceptance/acceptance_helper'

feature 'Change answer rating', '
  In order to show my opinion about answer content
  As an authenticated user but not author
  I want to be able to change answer rating
' do

  given(:user) { create(:user) }
  given(:answer) { create(:answer) }

  scenario 'Anyone but author vote for answer', js: true do
    sign_in(user)
    visit question_path(answer.question)

    expect(page).to have_content 'Rating: 0'
    click_on 'Like'

    expect(page).to have_content 'Rating: 1'
  end

  scenario 'Author of answer tries to vote for it', js: true do
    sign_in(answer.user)

    visit question_path(answer.question)
    expect(page).to_not have_link 'Dislike'
  end
end
