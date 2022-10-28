require 'rails_helper'

feature 'User can add badge to question', %q{
  In order to determine the award for the winner
  As an question's author
  I'd like to be able to add badge
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author_id: user.id) }

  scenario 'User adds badge when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Badge name', with: 'Badge'
    attach_file 'Image', ["#{Rails.root}/app/assets/images/badge.jpg"]

    click_on 'Ask'

    expect(page).to have_content 'Badge'
  end
end
