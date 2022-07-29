require 'acceptance/acceptance_helper'

feature 'View details of question', '
  In order to get more information about question
  As a user
  I want to be able to view details of question
' do

  given(:question) { create(:question) }

  scenario 'User view question with answers' do
    FactoryBot.create_list :answer, 2, question: question

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers_on_question = question.answers
    answers_on_question.each { |answer| expect(page).to have_content answer.body }
  end
end
