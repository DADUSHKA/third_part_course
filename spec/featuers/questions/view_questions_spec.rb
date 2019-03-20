require 'rails_helper'

feature 'User is able to view questions list', %q{
  Any user is able to view question list
} do

  given!(:questions) { create_list(:question, 3) }

  scenario 'User try to view existed questions list' do
    visit questions_path
    questions.each do |question|
      expect(page).to have_content question.title
    end
  end

  scenario 'User try to view non-existed questions list' do
    visit questions_path
    expect(page).to_not have_content questions
  end
end
