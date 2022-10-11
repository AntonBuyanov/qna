require 'rails_helper'

feature 'User can view the list of questions', %q{
  In order to find the question he is interested
  As an unauthenticated user
} do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, author_id: user.id) }

  describe 'Authenticated user' do
    scenario 'view the list of questions' do
      sign_in(user)

      visit questions_path
      questions.each do |question|
        expect(page).to have_content(question.title)
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'view the list of questions' do
      visit questions_path
      questions.each do |question|
        expect(page).to have_content(question.title)
      end
    end
  end
end
