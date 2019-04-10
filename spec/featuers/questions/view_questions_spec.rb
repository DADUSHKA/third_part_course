feature "User is able to view questions list", %q{
  Any user is able to view question list
} do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3) }

  scenario "User try to view existed questions list" do
    sign_in(user)
    visit questions_path
    questions.each do |question|
      expect(page).to have_content question.title
    end
  end

  scenario "Not registered user is looking at a list of issues" do
    visit questions_path
    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
