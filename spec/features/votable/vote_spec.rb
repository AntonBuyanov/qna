require 'rails_helper'

feature 'User can vote for the answer or question', %q{
  In order to be able to change the rating
  As an authenticated user
  I'd like to be able put a like or dislike
} do

  given!(:user) { create(:user) }
  given!(:user_not_author) { create(:user) }
  given!(:question) { create(:question, author_id: user.id) }
  given!(:answer) { create(:answer, question: question, author_id: user.id) }

  describe 'Authenticated user_not_author', js: true do
    background do
      sign_in(user_not_author)

      visit question_path(question)
    end

    scenario 'like for the another question' do
      within '.question' do
        click_on '+'

        expect(page).to have_content '1'
      end
    end

    scenario 'dislike for the another question' do
      within '.question' do
        click_on '-'

        expect(page).to have_content '-1'
      end
    end

    scenario 'cancel vote for the another question' do
      within '.question' do
        click_on '+'
        expect(page).to have_content '1'

        click_on 'Cancel vote'
        expect(page).to have_content '0'
      end
    end

    scenario 'like for the another answer' do
      within '.answers' do
        click_on '+'

        expect(page).to have_content '1'
      end
    end

    scenario 'dislike for the another answer' do
      within '.answers' do
        click_on '-'

        expect(page).to have_content '-1'
      end
    end

    scenario 'cancel vote for the another answer' do
      within '.answers' do
        click_on '+'
        expect(page).to have_content '1'

        click_on 'Cancel vote'
        expect(page).to have_content '0'
      end
    end
  end

  describe 'user is author', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'like for the your question' do
      within '.question' do
        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
        expect(page).to_not have_link 'Cancel vote'
      end
    end

    scenario 'like for the your answer' do
      within '.answers' do
        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
        expect(page).to_not have_link 'Cancel vote'
      end
    end
  end
end
