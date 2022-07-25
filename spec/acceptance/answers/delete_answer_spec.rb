require 'acceptance/acceptance_helper'

feature 'Delete answer', '
  In order to remove answer on answer
  As an answer author
  I want to be able to delete answer
' do

  given(:answer) { create(:answer) }

  scenario 'Author of answer delete it' do
    sign_in(answer.user)
    visit question_path(answer.question)

    click_on 'Delete answer'
    expect(page).to have_content 'You deleted your answer for this question'
    expect(current_path).to eq question_path(answer.question)
  end

  scenario 'Anybody but author tries to delete answer' do
    sign_in(create(:user))
    visit question_path(answer.question)

    expect(page).to have_no_css('#delete-answer')
  end
end
