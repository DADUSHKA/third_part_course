feature "The user, while on the question page, can write the answer to the question", %q{
  To write an answer to a question
  As an authenticated user
  I would like to go to the question page
} do

  given(:user) {create(:user)}
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'write the answer to the question', js: true do

      fill_in 'answer-text', with: 'text text text'
      click_on 'Reply'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Your answer successfully created.'
      within '.answers' do
        expect(page).to have_content 'text text text'
      end
    end

    scenario "write the answer with errors", js: true do
     click_on 'Reply'

     expect(page).to have_content "Body can't be blank"
   end
 end

 scenario 'Unauthenticated user write the answer to the question', js: true do
  visit question_path(question)
  fill_in 'answer-text', with: 'text text text'
  click_on 'Reply'

  expect(page).to have_content 'You need to sign in or sign up before continuing.'
end

end
