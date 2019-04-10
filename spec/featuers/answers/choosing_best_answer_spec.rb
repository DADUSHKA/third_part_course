feature "Author can choose the best answer", %q{
  As the author of the question
  I can choose the best answer
  To the question
} do
  given!(:user) { create(:user) }
  given!(:user1) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer1) { create(:answer, question: question, author: user) }
  given!(:answer2) { create(:answer, question: question, author: user) }

  describe "Non authenticated user" do
    scenario "can not choose the best answer" do
      visit question_path(question)
      expect(page).not_to have_link "Best answer"
    end
  end

  describe "Authenticated user" do
    describe "is not the author of the question" do
      scenario "can not choose the best answer" do
        sign_in(user1)
        visit question_path(question)

        expect(page).not_to have_link "Best answer"
      end
    end

    describe "if he is the author of the question" do
      scenario "can choose the best answer", js: true do
        sign_in(user)
        visit question_path(question)

        within(".answer-#{answer1.id}") do
          click_on "Best answer"
          expect(page).to have_content "Best answer of all"
          expect(page).to_not have_link "Best answer"
        end
      end
    end

    scenario "can chose another answer as the best one", js: true do
      sign_in(user)
      visit question_path(question)

      within(".answer-#{answer1.id}") do
        click_on "Best answer"
      end

      within(".answer-#{answer2.id}") do
        click_on "Best answer"
        expect(page).to have_content "Best answer of all"
        expect(page).to_not have_link "Best answer"
        expect(page).to_not have_selector "textarea"
      end

      within(".answer-#{answer1.id}") do
        expect(page).to have_link "Best answer"
        expect(page).to_not have_content "Best answer of all"
        expect(page).to_not have_selector "textarea"
      end
    end

    scenario "the best answer should be the first in the list", js: true do
      sign_in(user)
      visit question_path(question)

      within(".answer-#{answer1.id}") do
        click_on "Best answer"
        expect(page).to have_content "Best answer of all"
        expect(page).to_not have_link "Best answer"
      end
      expect(first(".answers li").text).to have_content "Best answer of all"
    end
  end
end
