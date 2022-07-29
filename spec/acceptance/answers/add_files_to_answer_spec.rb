require 'acceptance/acceptance_helper'

feature 'Add files to question', '
  In order to illustrate my answer
  As an answer author
  I want to be able to attach files
' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when answer question', js: true do
    fill_in 'Your answer', with: 'Some answer text'
    attach_file 'File', "#{Rails.root}/spec/acceptance/answers/add_files_to_answer_spec.rb"

    click_on 'Add answer'
    expect(page).to have_link 'add_files_to_answer_spec.rb'
  end
end