require 'acceptance/acceptance_helper'

feature 'Add files to question', '
  In order to illustrate my question
  As a question\'s author
  I want to be able to attach files
' do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds file when asks question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test body'
    attach_file 'File', "#{Rails.root}/spec/acceptance/questions/add_file_to_question_spec.rb"

    click_on 'Create'
  end
end