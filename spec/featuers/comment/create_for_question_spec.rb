require 'rails_helper'

feature 'User can create comments for question', %q{
  In order to create comments to question
  As an authenticated user
  I'd like to be able to set comments for question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'give comment for question', js: true do
      within '.question' do
        # save_and_open_page
        click_on 'Add comment'
        fill_in 'Comment body', with: 'My comment'
        click_on 'Save comment'

        expect(page).to_not have_selector "#Add-Question-Comment-#{question.id}"
      end

      within '.question-comments' do
        expect(page).to have_content 'My comment'
      end
    end

    context 'multiple session' do

    end

    scenario 'give comment with error', js: true do

    end
  end

  scenario 'Unauthenticated user tries set comment' do

  end
end
