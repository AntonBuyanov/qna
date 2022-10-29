require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author_id: user.id) }
  given!(:link) { create(:link, linkable: question) }

  scenario 'User adds links when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: link.name
    fill_in 'Url', with: link.url

    click_on 'Ask'

    expect(page).to have_link link.name
  end
end
