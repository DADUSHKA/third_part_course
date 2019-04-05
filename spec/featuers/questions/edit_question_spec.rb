require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do

  given!(:user) { create(:user) }
  given(:user1) { create(:user) }
  given(:question) { create(:question, author: user1) }
  given!(:questions) { create_list(:question, 1, author: user) }

  scenario 'Unauthenticated can not edit question' do
    visit questions_path

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit questions_path

      questions.each do |question|
        expect(page).to have_content question.title
        click_on 'Edit question'
      end
    end

    scenario 'edits his question' do
        fill_in 'Your question', with: 'edited question'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to have_content 'edited question'
        expect(page).to_not have_selector 'textarea'
        expect(page).to have_content 'The question was updated successfully.'
    end

    scenario 'edits his question with errors' do
        fill_in 'Your question', with: ''
        click_on 'Save'

        expect(page).to have_content "Title can't be blank"
    end
  end

    scenario "tries to edit other user's question" do
      sign_in(user)
      visit questions_path
      expect(page).to have_no_link('Edit', href: question_path(question))
    end
end
