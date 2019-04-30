require 'rails_helper'

feature 'User can create comment for answer', %q{
  In order to create comment to answer
  As an authenticated user
  I'd like to be able to set comment for answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'give comment for answer', js: true do
      within '.answers' do
        click_on 'Add comment'
        fill_in 'Comment body', with: 'My answer comment'
        click_on 'Save comment'

        expect(page).to_not have_selector "#Answer-comment-#{answer.id}"
      end

      within ".answer-comments-#{answer.id}" do
        expect(page).to have_content 'My answer comment'
      end
    end

    context 'multiple session' do
      scenario 'comment appears on another user page', js: true do

      end
    end

    scenario 'give comment with error', js: true do

    end
  end

  scenario 'Unauthenticated user tries set comment' do

  end
end
