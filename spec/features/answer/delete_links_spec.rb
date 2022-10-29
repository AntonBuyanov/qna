require 'rails_helper'

feature 'User can delete links to answer', %q{
  In order to clear additional information
  As an answer's author
  I'd like to be able to delete links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author_id: user.id) }
  given(:answer) { create(:answer, question: question, author: user) }
  given!(:link) { create(:link, linkable: answer) }

  scenario 'Unauthenticated user tried delete link to answer', js: true do
    visit question_path(question)
    within("#answer-#{answer.id}") do
      expect(page).to_not have_link 'Delete link'
    end
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'delete link his answer' do
      within("#answer-#{answer.id}") do
        click_on 'Delete link'
        expect(page).to_not have_content :link
      end
    end
  end
end
