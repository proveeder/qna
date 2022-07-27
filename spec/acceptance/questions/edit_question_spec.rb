require 'acceptance/acceptance_helper'

feature 'Edit question', '
  In order to fix mistake or add new info
  As a question author
  I want to be able to edit question
' do

  given(:question) { create(:question) }

  scenario 'Author of question edit question', js: true do
    sign_in question.user
    visit question_path(question)

    within('.question') do
      click_on 'Edit question'

      fill_in 'Title', with: 'Changed title'
      fill_in 'Body', with: 'Changed body'
      click_on 'Update'
    end

    expect(page).to have_content('Changed title')
    expect(page).to have_content('Changed body')
  end

  scenario 'Author of question edit question with invalid args', js: true do
    sign_in question.user
    visit question_path(question)

    within('.question') do
      click_on 'Edit question'

      fill_in 'Title', with: ''
      fill_in 'Body', with: ''
      click_on 'Update'
    end

    expect(find_by_id('question-title')).to have_content(question.title)
    expect(find_by_id('question-body')).to have_content(question.body)

    expect(page).to have_content('Title can\'t be blank')
    expect(page).to have_content('Body can\'t be blank')
  end

  scenario 'Anybody but author tries to edit question' do
    sign_in create(:user)
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end
end
