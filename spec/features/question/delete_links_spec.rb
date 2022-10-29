require 'rails_helper'

feature 'User can delete links to question', %q{
  In order to clear additional information
  As an question's author
  I'd like to be able to delete links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:link) { create(:link, linkable: question) }

  scenario 'Unauthenticated user tried delete link to question', js: true do
    visit question_path(question)
    within('.question') do
      expect(page).to_not have_link 'Delete link'
    end
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'delete link his question' do
      within('.question') do
        click_on 'Delete link'
        expect(page).to_not have_content :link
        save_and_open_page
      end
    end
  end
end
