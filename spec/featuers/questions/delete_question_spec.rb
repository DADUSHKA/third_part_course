require 'rails_helper'

feature 'User can delete his question or answer' do
   given(:user) { create(:user) }
   given(:user1) { create(:user) }
   given(:question) { create(:question, author: user) }
   given(:question1) { create(:question, author: user1) }

  scenario 'Authenticated user can delete his question' do
    sign_in(user)

    visit question_path(question)
    expect(page).to have_content question.body
    expect(page).to have_content question.title

    click_on 'Delete question'

    expect(page).to have_content 'Question was successfully deleted'
    expect(current_path).to eq questions_path
    expect(page).to have_no_content question.body
    expect(page).to have_no_content question.title
  end

  scenario "Authenticated user can not delete another's question" do
    sign_in(user)

    visit question_path(question1)
    expect(page).to have_content question.body
    expect(page).to have_content question.title
    expect(page).to have_no_link 'Delete question'
  end

  scenario "Non-authenticated user can not delete another's question" do
    visit question_path(question)

    expect(page).to have_no_link('Delete question')
  end
end
