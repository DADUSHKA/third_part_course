feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) {create(:user)}
  given!(:question) {create(:question)}
  given(:gist_url) {'https://gist.github.com/DADUSHKA/598b316da2fd9817e699f0b85b7f9cdf'}

  scenario 'User adds link when give an answer', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in "answer-text", with: 'My answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Reply'
# save_and_open_page
    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end

end
