require 'acceptance/acceptance_helper'

feature 'Edit answer', '
  In order to remove fix error or add information
  As an answer author
  I want to be able to edit answer
' do

  given(:answer) { create(:answer) }

  scenario 'Author of answer edit it with valid data' do
    sign_in(answer.user)
    visit question_path(answer.question)
  end

  scenario 'Author of answer edit it with invalid data'

  scenario 'Anybody but author tries to delete answer' do
    # re-sign-in
    sign_in(create(:user))

    visit question_path(answer.question)
  end
end

