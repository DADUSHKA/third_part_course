require 'rails_helper'

feature 'User can delete his answer' do
  given(:user) { create(:user)}
  given(:user1) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:question1) { create(:question, author: user1) }
  given(:answers) { create_list(:answer, question: question) }
  given(:answer1) { create(:answer, question: question1) }

  scenario 'Authenticated user can delete his answer' do
    sign_in(user)

    visit question_path(question)

    expect(page).to have_content(question.body)

       question.answers.each do |a|
        expect(page).to have_content(a.body)
      end
    expect(page).to have_content 'Delete'

    click_on 'Delete'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Answer was successfully deleted'
  end

  scenario "Authenticated user can not delete another's answer" do
    sign_in(user)

    visit question_path(question)

    expect(page).to have_no_link('Delete', href: answer_path(answer1))
  end

  scenario "Non-authenticated user can not delete another's answer" do
    visit question_path(question)
    expect(page).to have_no_link('Delete', href: answer_path(answer1))
  end
end
