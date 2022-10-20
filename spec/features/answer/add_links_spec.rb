require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author_id: user.id) }
  given(:gist_url) { 'https://gist.github.com/AntonBuyanov/ff3d4d170523750d5903fb1206876b18' }

  scenario 'User adds links when add answer', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'add links'

    fill_in 'Your answer', with: 'Test answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Create answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end

  scenario 'User adds links when add answer with errors', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'add links'

    fill_in 'Your answer', with: 'Test answer'
    fill_in 'Url', with: 'google.ru'

    click_on 'Create answer'

    expect(page).to have_content 'Links url is invalid'
    expect(page).to have_content "Links name can't be blank"
  end
end
