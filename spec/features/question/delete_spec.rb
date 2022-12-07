require 'rails_helper'

feature 'User can only delete his question', %q{
  In order to create new question
  As an authenticated user
  I'd like to be able delete to the question
} do

  given(:user) { create(:user) }
  given(:user_not_author) { create(:user) }
  given!(:question) { create(:question, author_id: user.id) }

  scenario 'Authenticated user delete his question' do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      click_on 'Delete'
    end

    expect(page).to have_content 'Your question successfully delete.'
  end

  scenario 'Authenticated user delete not your own question' do
    sign_in(user_not_author)
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'Unauthenticated user delete question' do
    visit question_path(question)
    within '.question' do
      expect(page).to_not have_link 'Delete'
    end
  end
end
