require 'rails_helper'

feature 'User can sign out', %q{
  In order to restrict access to my resource
  As an authenticated user
  I'd like to be able to sing out
} do

  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'Registered use tries to sign out' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    visit questions_path
    click_on 'Sign out'
    expect(page).to have_content 'Signed out successfully.'
  end
end
