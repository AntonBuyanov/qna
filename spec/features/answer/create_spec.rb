require 'rails_helper'

feature 'User can create answer while on the page question', %q{
  In order to share the answer for the community
  As an authenticated user
  I'd like to be able to write an answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author_id: user.id) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'create answer' do
      fill_in 'Your answer', with: 'Test answer'
      click_on 'Create answer'

      expect(page).to have_content 'Test answer'
    end

    scenario 'create answer with errors' do
      click_on 'Create answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to create answer' do
    visit question_path(question)
    click_on 'Create answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
