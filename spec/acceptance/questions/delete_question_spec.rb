require 'acceptance/acceptance_helper'

feature 'Delete question', '
  In order to remove question from internet
  As a question authore
  I want to be able to delete question
' do

  given(:users) { create_list(:user, 2) }

  before do
    sign_in(users[0])
    create_question
  end

  scenario 'Author of question delete question' do
    click_on 'Delete question'
    expect(page).to have_content 'You deleted question successfully'
    expect(current_path).to eq questions_path
  end

  scenario 'Anybody but author tries to delete question' do
    sign_out
    sign_in(users[1])

    expect(page).to have_no_css('#delete-question')
  end
end
