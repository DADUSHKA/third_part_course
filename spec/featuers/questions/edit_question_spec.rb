feature "User can edit his question", %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do
  given!(:user) { create(:user) }
  given(:user1) { create(:user) }
  given(:question) { create(:question, author: user1) }
  given!(:question1) { create(:question, :with_file, author: user) }
  given(:github_url) { "https://github.com" }

  scenario "Unauthenticated can not edit question" do
    visit questions_path

    expect(page).to_not have_link "Edit question"
  end

  describe "Authenticated user", js: true do
    background do
      sign_in(user)
      visit questions_path
      expect(page).to have_content question1.title
      click_on "Edit question"
    end

    scenario "edits his question" do
      fill_in "Your question", with: "edited question"
      click_on "Save"

      expect(page).to_not have_content question1.title
      expect(page).to have_content "edited question"
      expect(page).to_not have_selector "textarea"
      expect(page).to have_content "The question was updated successfully."
    end

    scenario "edits his question with errors" do
      fill_in "Your question", with: ""
      click_on "Save"

      expect(page).to have_content "Title can't be blank"
    end

    scenario "edits a question with attached file" do
      fill_in "Your question", with: "edited question"
      attach_file "File", ["#{Rails.root}/spec/rails_helper.rb"]

      click_on "Save"
      visit question_path(question1)

      expect(page).to have_link "test.pdf"
      expect(page).to have_link "rails_helper.rb"
    end

    scenario "delete an attached question file" do
      click_on "Save"
      click_on "Edit question"
      click_on "Delete this file"
      expect(page).to_not have_link "test.pdf"
    end

    scenario "adding a link when editing a question" do
      click_on "add link"

      within all(".nested-fields")[0] do
        fill_in "link-name", with: "My link"
        fill_in "Url", with: github_url
      end

      click_on "add link"

      within all(".nested-fields")[0] do
        fill_in "link-name", with: "My link2"
        fill_in "Url", with: github_url
      end

      click_on "Save"
      visit question_path(question1)

      expect(page).to have_link "My link", href: github_url
      expect(page).to have_link "My link2", href: github_url
    end
  end

  scenario "can remove the link from your question", js: true do
    link = create(:link, linkable: question1)

    sign_in(user)
    visit question_path(question1)
    expect(page).to have_link "My Link", href: github_url

    click_on "Delete link"

    expect(page).to_not have_link "My link", href: github_url
  end

  scenario "tries to edit other user's question" do
    sign_in(user)
    visit questions_path
    expect(page).to have_no_link("Edit", href: question_path(question))
  end
end
