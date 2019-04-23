feature 'User can vote for the question he likes', %q{
  In order to to increase the question rating
  As an authenticated user
  I'd like to be able to up rating for question
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'not owner question' do
    background do
      sign_in(user2)
      visit question_path(question)
    end

    scenario 'to vote like only once', js: true do
      click_on 'like'
      within '.question' do
        expect(page).to have_content 'Question like: 1'
        expect(page).to_not have_link 'like'
        expect(page).to_not have_link 'dislike'
      end
    end

    scenario 'to vote is not enjoyed only once', js: true do
      # click_on 'dislike'

      # within '.question' do
      #   expect(page).to have_content 'Question dislike: 1'
      #   expect(page).to_not have_link 'like'
      #   expect(page).to_not have_link 'dislike'
      # end
    end

    scenario 'cancel rating', js: true do
    #   click_on 'deselecting'

    #   within '.question' do
    #     expect(page).to have_link 'deselecting'
    #   end
    # end
  end

  describe 'owner question' do
    # background do
    #   sign_in(owner)
    #   visit question_path(question)
    end

    scenario 'can not change rating' do
      # expect(page).to_not have_link 'like'
      # expect(page).to_not have_link 'dislike'
    end
  end
   # save_and_open_page
end

