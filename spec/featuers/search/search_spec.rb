require 'sphinx_helper'

feature 'user can search questions, answers, comments, users', %q{
  In order to get list of questions, answers, comments, users  from a community
  As an any user
  I'd like to be able search information
} do
  let!(:user) { create(:user) }
  let!(:another_user) { create(:user) }
  let!(:question) { create(:question, author: user, title: 'User Question',
                                                              body: 'Question body') }
  let!(:another_question) { create(:question, author: another_user,
                  title: 'Not_user Question_another', body: 'Question body_another') }
  let!(:answer) { create(:answer, question: question, author: user,
                                                                body: 'User answer') }
  let!(:another_answer) { create(:answer, question: another_question, author: another_user,
                                                        body: 'User another_answer') }
  let!(:comment) { create(:comment, commentable: question, user: user,
                                                               body: 'User comment') }
  let!(:another_comment) { create(:comment, commentable: question, user: another_user,
                                                           body: 'Not_user comment') }

  before { visit root_path }

  scenario 'search globally resourse', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within '.search' do
        fill_in 'query', with: 'User'
        select('Global search', from: 'type')
        click_on 'Search'
      end
      expect(current_path).to eq search_path

      expect(page).to have_content 'User answer'
      expect(page).to have_content 'User another_answer'
      expect(page).to have_content 'User comment'
      expect(page).to have_content 'User Question'
      expect(page).to_not have_content 'Not_user Question'
      expect(page).to have_content 'User another_answer'
      expect(page).to_not have_content 'Not_user comment'
    end
  end

  scenario 'search globally user', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within '.search' do
        fill_in 'query', with: question.author.email
        select('Global search', from: 'type')
        click_on 'Search'
      end
      expect(current_path).to eq search_path

      expect(page).to have_content question.author.email
      expect(page).to_not have_content another_question.author.email
      expect(page).to have_content 'User answer'
      expect(page).to_not have_content 'User another_answer'
      expect(page).to have_content 'User comment'
      expect(page).to_not have_content 'Not_user comment'
      expect(page).to have_content 'User Question'
      expect(page).to_not have_content 'Not_user Question'
    end
  end

  scenario 'search a question', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within '.search' do
        fill_in 'query', with: 'Question body'
        select('Question', from: 'type')
        click_on 'Search'
      end
      expect(current_path).to eq search_path
      expect(page).to have_content 'User Question'
      expect(page).to_not have_content 'Not_user Question_another'
    end
  end

  scenario 'search answer', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within '.search' do
        fill_in 'query', with: 'User answer'
        select('Answer', from: 'type')
        click_on 'Search'
      end
      expect(current_path).to eq search_path
      expect(page).to have_content 'User answer'
      expect(page).to_not have_content 'User another_answer'
    end
  end

  scenario 'search comment', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within '.search' do
        fill_in 'query', with: 'User comment'
        select('Comment', from: 'type')
        click_on 'Search'
      end
      expect(current_path).to eq search_path
      expect(page).to have_content 'User comment'
      expect(page).to_not have_content 'Not_user comment'
    end
  end

  scenario 'search users', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within '.search' do
        fill_in 'query', with: question.author.email
        select('User', from: 'type')
        click_on 'Search'
      end
      expect(current_path).to eq search_path
      expect(page).to have_content question.author.email
      expect(page).to_not have_content another_question.author.email
    end
  end

  scenario 'search blank query', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within '.search' do
        fill_in 'query', with: ''
        click_on 'Search'
      end
      expect(current_path).to eq search_path
      expect(page).to have_content 'No results.'
    end
  end
end
