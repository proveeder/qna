require 'acceptance/acceptance_helper'

# only 2 written cause they are too similar, I figured out how to run them at all!
feature 'Search for specific question', '
  In order to find more relevant information
  As any one
  I want to be able to make word-specific search
' do

  given(:question) { create(:question) }
  given(:answer) { create(:answer) }

  scenario 'User search for question', sphinx: true do
    visit root_path

    fill_in 'Text to search', with: question.title
    choose('Question')
    click_on 'Search'
    expect(page).to have_link question.title
  end

  scenario 'User search for answer', sphinx: true do
    visit root_path

    fill_in 'Text to search', with: answer.body.split.first
    choose('Answer')
    click_on 'Search'
    expect(page).to have_link answer.body
  end
end
