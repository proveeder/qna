require 'rails_helper'

feature 'View all questions', '
  In order to see answers for particular question or give my answer
  As a user
  I want to be able to see list of all questions
' do

  scenario 'Some questions asked' do
    create_list(:question, 2)

    visit questions_path

    expect(find(:xpath, './/table/thead/tr/th').text).to eq 'All questions:'
    Question.all.each do |q|
      expect(find("#question-#{q.id}").text).to eq q.title
    end
  end

  scenario 'No questions asked' do
    visit questions_path

    expect(find(:xpath, './/table/thead/tr/th').text).to eq 'All questions:'
    expect(find(:xpath, './/table/tbody/tr/td').text).to have_content 'No questions asked yet'
  end
end
