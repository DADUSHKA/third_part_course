feature 'User can sign up', %q{
  In order to user the service
  User can sign up
} do
  scenario 'User sign up' do
    visit new_user_registration_path
    fill_in 'user_email', with: 'user@mail.com'
    password = '12345678'
    fill_in 'user_password', with: password
    fill_in 'user_password_confirmation', with: password
    click_on 'Sign up'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
end
