require 'rails_helper'

feature 'User can only delete his answers', %q{
  In order to create new answer
  As an authenticated user
  I'd like to be able delete to the answer
} do

  given(:user) { create(:user) }
  given(:user_not_author) { create(:user) }
  given!(:question) { create(:question, author_id: user.id) }
  given!(:answer) { create(:answer, question_id: question.id, author_id: user.id) }

  describe 'Authenticated user', js: true do
    scenario 'delete his answer', js: :true do
      sign_in(user)
      visit question_path(question)
      click_on 'Delete answer'

      expect(page).to_not have_content answer.body
    end

    scenario 'delete not your own answer' do
      sign_in(user_not_author)
      visit question_path(question)

      expect(page).to_not have_link 'Delete answer'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tried delete question' do
      visit question_path(question)
      expect(page).to_not have_link 'Delete answer'
    end
  end
end
