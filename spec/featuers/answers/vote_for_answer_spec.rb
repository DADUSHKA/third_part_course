 feature 'User can vote for the answer he likes', %q{
  In order to to increase the answer rating
  As an authenticated user
  I'd like to be able to up rating for answer
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  describe 'not owner question' do
    background do
      sign_in(user2)
      visit question_path(question)
    end

    scenario 'to vote like only once', js: true do
      within '.answers' do
        click_on 'like'

        expect(page).to have_content 'Answer like: 1'
        expect(page).to_not have_link 'like'
        expect(page).to_not have_link 'dislike'
      end
    end

    scenario 'to vote is not enjoyed only once', js: true do
      within '.answers' do
        click_on 'dislike'

        expect(page).to have_content 'Answer like: -1'
        expect(page).to_not have_link 'like'
        expect(page).to_not have_link 'dislike'
      end
    end

    scenario 'cancel rating', js: true do
      within '.answers' do
        click_on 'dislike'
        click_on 'deselecting'

        expect(page).to have_content 'Answer like: 0'
        expect(page).to_not have_link 'deselecting'
      end
    end
  end

  describe 'owner question' do
     background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can not change rating' do
      within '.answers' do
        expect(page).to_not have_link 'like'
        expect(page).to_not have_link 'dislike'
      end
    end
  end
end

