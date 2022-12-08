require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do

  given(:user) { create(:user) }
  given!(:user_not_author) { create(:user) }
  given!(:question) { create(:question, author_id: user.id) }
  given(:link) { create(:link, linkable: question) }

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: :true do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits his question with attach file' do
      within '.question' do
        click_on 'Edit'

        fill_in 'question_title', with: 'Test question'
        fill_in 'question_body', with: 'text text text'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'Test question'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'remove file his question' do
      within '.question' do
        click_on 'Edit'

        attach_file 'File', ["#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
        click_on 'Delete file'
        expect(page).to_not have_link 'spec_helper.rb'
      end
    end

    scenario 'edits his question with errors' do
      within '.question' do
        click_on 'Edit'

        fill_in 'question_title', with: ''
        fill_in 'question_body', with: ''
        click_on 'Save'
      end

      within '.question-errors' do
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'add link to his question' do
      within('.question') do
        click_on 'Edit'
        click_on 'Add link'

        fill_in 'Link name', with: link.name
        fill_in 'Url', with: link.url
        click_on 'Save'

        expect(page).to have_link link.name
      end
    end
  end

  scenario 'Authenticated user not author tries to edit question' do
    sign_in(user_not_author)
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end
end
