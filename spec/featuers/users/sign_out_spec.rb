feature "Logged in user can sign out", %q{
  In order to finish work
  logged in user can sign out
} do
  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario "Logged in user can sign out" do
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_on "Log in"
    expect(current_path).to eq root_path
    expect(page).to have_content "Signed in successfully."

    click_on "Log out"
    expect(current_path).to eq root_path
    expect(page).to have_content "Signed out successfully."
  end
end
