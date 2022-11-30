require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do

  given(:user) { create(:user) }
  given!(:user_not_author) { create(:user) }
  given!(:question) { create(:question, author_id: user.id) }
  given!(:answer) { create(:answer, question: question, author_id: user.id) }
  given(:link) { create(:link, linkable: answer) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits his answer' do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Your answer', with: 'edited answer'

        click_on 'Save'

        expect(page).to have_content 'edited answer'
      end
    end

    scenario 'remove file his answer' do
      within '.answers' do
        click_on 'Edit'
        attach_file 'File', ["#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
      end

      within '.answers' do
        click_on 'Delete file'
        expect(page).to_not have_link 'spec_helper.rb'
      end
    end

    scenario 'edits his answer with errors' do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Your answer', with: ''
        click_on 'Save'
      end

      within '.answer-errors' do
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'add link to his answer' do
      within("#answer-#{answer.id}") do
        click_on 'Edit'
        click_on 'Add link'

        fill_in 'Link name', with: link.name
        fill_in 'Url', with: link.url
        click_on 'Save'

        expect(page).to have_link link.name
      end
    end
  end

  scenario 'Authenticated user not author tries to edit answer' do
    sign_in(user_not_author)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end
end
