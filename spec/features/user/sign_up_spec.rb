require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask questions and write answer
  As an authenticated user
  I'd like to be able to sing up
} do

  background { visit questions_path }

  describe 'Successful registration' do
    scenario 'Sign up is valid params' do
      click_on 'Signup'
      fill_in 'Email', with: 'email@yandex.ru'
      fill_in 'Password', with: '123456'
      fill_in 'Password confirmation', with: '123456'

      click_on 'Sign up'
      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end
  end

  describe 'Unsuccessful registration' do
    given(:user) { create(:user) }

    scenario 'Sign up is invalid params' do
      click_on 'Signup'
      fill_in 'Email', with: 'email'
      fill_in 'Password', with: '123456'
      fill_in 'Password confirmation', with: '123456'

      click_on 'Sign up'
      expect(page).to have_content 'Email is invalid'
    end

    scenario 'The user is already registered' do
      click_on 'Signup'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: '123456'
      fill_in 'Password confirmation', with: '123456'

      click_on 'Sign up'
      expect(page).to have_content 'Email has already been taken'
      save_and_open_page
    end
  end
end
