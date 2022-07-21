require 'rails_helper'

feature 'View details of question', '
  In order to get more information about question
  As a user
  I want to be able to view details of question
' do

  scenario 'Authenticated user answer question' do
    @question = create(:question)

    visit question_path(@question)

    expect(page).to have_content @question.title
    expect(page).to have_content @question.body
  end
end
