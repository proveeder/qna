require 'acceptance/acceptance_helper'

feature 'Search for specific question', '
  In order to find more relevant information
  As any one
  I want to be able to make word-specific search
' do

  given(:question) { create(:question) }

  scenario 'User search for question', sphinx: true do
    visit root_path

    fill_in 'Text to search', with: question.title
    choose('Question')
    click_on 'Search'
    expect(page).to have_link question.title
  end
end
