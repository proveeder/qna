require 'acceptance/acceptance_helper'

feature 'Set best answer', '
  In order to mark answer that solves my problem
  As question\'s author
  I want to be able to set best answer
' do

  given(:answer) { create(:answer) }

  scenario 'Author of question mark answer as best', js: true do
    sign_in answer.question.user
    visit question_path(answer.question)

    click_on 'Mark as best'
    within('.best-answer') do
      expect(page).to have_content answer.body
    end
  end

  scenario 'Author of question tries to mark answer as best but no answers present' do
    question = create(:question)
    visit question_path(question)

    expect(page).not_to have_link 'Mark as best'
  end

  scenario 'Anyone but author tries to mark answer as best' do
    # re-sign-in
    sign_in(create(:user))

    visit question_path(answer.question)
    expect(page).not_to have_link 'Mark as best'
  end
end

