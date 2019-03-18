require 'rails_helper'

feature 'User can delete his question or answer' do
  let(:user) { create(:user) }
  let(:user1) { create(:user) }

  scenario 'Authenticated user can delete his question' do
    sign_in(user)

    question = create(:question, author: user)

    visit question_path(question)

    expect(page).to have_content question.body
    expect(page).to have_content question.title
    click_on 'Delete question'

    expect(page).to have_content 'Question was successfully deleted'
    expect(current_path).to eq questions_path
    expect(page).to have_no_content question.body
    expect(page).to have_no_content question.title
  end

  scenario 'Authenticated user can not delete another''s question' do
    # sign_in(user)

    # question = create(:question, author: user1)

    # visit question_path(question)

    # expect(page).to have_no_content 'Delete question'
  end

  scenario 'Non-authenticated user can not delete another''s question' do
    question = create(:question, author: user1)
    visit question_path(question)

    expect(page).to have_no_content('Delete question')
  end

end
