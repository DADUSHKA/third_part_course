feature "User can delete his answer", %q{
  As the user who created the response
  I want to delete it
} do
  given(:user) { create(:user) }
  given(:user1) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:question1) { create(:question, author: user1) }

  scenario "Authenticated user can delete his answer", js: true do
    sign_in(user)

    answer = create(:answer, question: question, author: user)

    visit question_path(question)
    expect(page).to have_content answer.body
    expect(page).to have_link("Delete", href: answer_path(answer))

    click_on "Delete"

    expect(current_path).to eq question_path(question)
    expect(page).to have_content "Answer was successfully deleted"
    expect(page).to have_no_content answer.body
  end

  scenario "Authenticated user can not delete another's answer" do
    sign_in(user)

    answer = create(:answer, question: question1)
    visit question_path(question1)
    expect(page).to have_no_link("Delete", href: answer_path(answer))
  end

  scenario "Non-authenticated user can not delete another's answer" do
    answer = create(:answer, question: question1)
    visit question_path(question)
    expect(page).to have_no_link("Delete", href: answer_path(answer))
  end
end
