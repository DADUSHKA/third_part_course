require 'rails_helper'

feature "The user, while on the question page, can write the answer to the question", %q{
  To write an answer to a question
  As an authenticated user
  I would like to go to the question page
} do

    given(:user) {create(:user)}
    let(:question) { create(:question) }

    describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'write the answer to the question' do
      fill_in 'Body', with: 'text text text'
      click_on 'Reply'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'text text text'
    end

    scenario "write the answer with errors" do
     click_on 'Reply'

     expect(page).to have_content "Body can't be blank"
    end
  end

    scenario 'Unauthenticated user write the answer to the question' do
    visit question_path(question)
    click_on 'Reply'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
