require 'rails_helper'

feature 'User can view the question and the answers to it', %q{
  In order to find the question and answers to it he is interested
  As an unauthenticated user
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  describe 'Authenticated user' do
    scenario 'view the list of question and answers to it' do
      sign_in(user)

      visit question_path(question)
      answers.each do |answers|
        expect(page).to have_content(answers.body)
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'view the list of question and answers to it' do
      visit question_path(question)
      answers.each do |answers|
        expect(page).to have_content(answers.body)
      end
    end
  end
end
