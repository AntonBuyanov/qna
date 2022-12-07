require 'sphinx_helper'

feature 'User can search for questions, answers, users, comments', %q{
  In order to find nedded information
  As a user
  I'd like to be able to search info
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, author_id: user.id) }

  background { visit questions_path }

  scenario 'User searches in All scope no result', sphinx: true do
    ThinkingSphinx::Test.run do
      within '.search' do
        fill_in :request, with: 'nocont'
        click_on 'Search'
      end

      expect(page).to have_content 'No result'
    end
  end

  scenario 'User searches in All scope success', sphinx: true do
    ThinkingSphinx::Test.run do
      within '.search' do
        fill_in :request, with: question.title
        click_on 'Search'
      end

      expect(page).to have_content question.title
    end
  end
end
