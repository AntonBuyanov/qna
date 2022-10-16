require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do

  given(:user) { create(:user) }
  given!(:user_not_author) { create(:user) }
  given!(:question) { create(:question, author_id: user.id) }

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: :true do
    scenario 'edits his question' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit question'

      within '.question' do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'Test question'
        expect(page).to_not have_selector 'textarea'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edits his question with errors' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit question'

      within '.question' do
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Save'
      end

      within '.question-errors' do
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's question" do
      sign_in(user_not_author)
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_link 'Edit question'
      end
    end
  end
end
