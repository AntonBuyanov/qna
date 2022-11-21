require 'rails_helper'

feature 'User can sign in with OAuth', %q{
  In order to sign in easily
  As a guest
  I'd like to be able to sing in with OAuth
} do

  OmniAuth.config.test_mode = true

  background do
    visit new_user_session_path
  end

  given!(:user) { create(:user, email: 'qna@gmail.com')}

  scenario 'Sign in with Vkontakte' do
    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new(
      provider: 'vkontakte', uid: '123456', info: { email: 'qna@gmail.com' }
    )

    click_on 'Sign in with Vkontakte'
    expect(page).to have_content 'Successfully authenticated from vkontakte account.'
  end

  scenario 'Sign in with Github' do
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      provider: 'github', uid: '123456', info: { email: 'qna@gmail.com' }
    )

    click_on 'Sign in with GitHub'
    expect(page).to have_content 'Successfully authenticated from github account.'
  end
end
