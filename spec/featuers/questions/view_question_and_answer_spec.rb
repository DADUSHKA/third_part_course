require 'rails_helper'

feature 'User can view a question and its answers', %q{
  In order to have new knowledge, user can view
  any questions and those answers
} do

  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  scenario 'User can view a question and its answers' do
    visit question_path(question)
    expect(page).to have_content(question.body)

     question.answers.each do |a|
      expect(page).to have_content(a.body)
    end
  end
end
