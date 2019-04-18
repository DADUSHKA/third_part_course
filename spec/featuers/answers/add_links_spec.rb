feature "User can add links to answer", %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given(:github_url) { "https://github.com" }
  given(:gist_url) { "https://gist.github.com/DADUSHKA/598b316da2fd9817e699f0b85b7f9cdf" }

  describe "Links to answer" do
    before do
      sign_in(user)
      visit question_path(question)
    end
    scenario "User adds links when give an answer", js: true do
      fill_in "answer-text", with: "My answer"

      within all(".nested-fields")[0] do
        fill_in "link-name", with: "My link"
        fill_in "Url", with: github_url
      end

      click_on "add link"

      within all(".nested-fields")[1] do
        fill_in "link-name", with: "My link2"
        fill_in "Url", with: github_url
      end

      click_on "Reply"

      within ".answers" do
        expect(page).to have_link "My link", href: github_url
        expect(page).to have_link "My link2", href: github_url
      end
    end

    scenario "User adds link to gist", js: true do
      fill_in "answer-text", with: "My Answer"

      within all(".nested-fields")[0] do
        fill_in "link-name", with: "My gist"
        fill_in "Url", with: gist_url
      end

      click_on "Reply"

      within ".answers" do
        expect(page).to_not have_css ".gist-file"
      end
    end
  end
end
