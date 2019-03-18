require 'rails_helper'

feature 'Authenticated user can answer a question', %q{
  In order to help, authenticated user can answer
  a question
} do

  given(:user) {create(:user)}
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  scenario 'Authenticated user can answer a question' do
    sign_in(user)

    visit question_path(question)
    fill_in 'answer_body', with: answer
    click_on 'Reply'

    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content answer
  end

  scenario 'Non-authenticated user can not answer a question' do
    visit question_path(question)
    fill_in 'answer_body', with: answer
    click_on 'Reply'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Authenticated user recieves an error using invalid params' do
    sign_in(user)
    visit question_path(question)
    click_on 'Reply'

    expect(page).to have_content "Body can't be blank"
  end
end
