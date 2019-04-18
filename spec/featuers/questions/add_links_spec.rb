feature "User can add links to question", %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:github_url) { "https://github.com" }
  given(:gist_url) { "https://gist.github.com/DADUSHKA/598b316da2fd9817e699f0b85b7f9cdf" }

  describe "Links to question" do
    before do
      sign_in(user)
      visit new_question_path
    end
    scenario "User adds links when asks question", js: true do
      fill_in "Title", with: "Test question"
      fill_in "Body", with: "text text text"

      within all(".nested-fields")[0] do
        fill_in "link-name", with: "My link"
        fill_in "Url", with: github_url
      end

      click_on "add link"

      within all(".nested-fields")[1] do
        fill_in "link-name", with: "My link2"
        fill_in "Url", with: github_url
      end

      click_on "Create"

      expect(page).to have_link "My link", href: github_url
      expect(page).to have_link "My link2", href: github_url
    end

    scenario "User adds link to gist", js: true do
      fill_in "Title", with: "Text question"
      fill_in "Body", with: "Text body"

      fill_in "link-name", with: "My gist"
      fill_in "Url", with: gist_url
      click_on "Create"

      expect(page).to have_css ".gist-file"
    end
  end
end
