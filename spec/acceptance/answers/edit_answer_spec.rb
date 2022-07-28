require 'acceptance/acceptance_helper'

feature 'Edit answer', '
  In order to remove fix error or add information
  As an answer author
  I want to be able to edit answer
' do

  given(:answer) { create(:answer) }

  scenario 'Author of answer edit it', js: true do
    sign_in(answer.user)
    visit question_path(answer.question)

    click_on 'Edit'
    fill_in 'Changed body', with: 'Changed answer body'

    click_on 'Edit'

    expect(page).to have_content 'Changed answer body'
  end

  scenario 'Author of answer edit it with invalid data', js: true do
    sign_in(answer.user)
    visit question_path(answer.question)

    click_on 'Edit'
    click_on 'Edit'
    expect(page).to have_content 'Some answer text'
  end

  scenario 'Anybody but author tries to delete answer' do
    # re-sign-in
    sign_in(create(:user))

    visit question_path(answer.question)

    expect(page).not_to have_link 'Edit'
  end
end

