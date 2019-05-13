require 'rails_helper'

RSpec.describe Ability do

  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should be_able_to :read, Award }
    it { should be_able_to :read, Link }
    it { should be_able_to :read, Vote }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }


    it { should be_able_to :update, create(:question, author: user), user: user }
    it { should_not be_able_to :update, create(:question, author: other_user), user: user }

    it { should be_able_to :update, create(:answer, author: user), user: user }
    it { should_not be_able_to :update, create(:answer, author: other_user), user: user }

    it { should be_able_to :destroy, create(:question, author: user), user: user }
    it { should_not be_able_to :destroy, create(:question, author: other_user), user: user }

    it { should be_able_to :destroy, create(:answer, author: user), user: user }
    it { should_not be_able_to :destroy, create(:answer, author: other_user), user: user }

    context 'assigning_as_best' do
      let(:question) { create(:question, author: user) }
      let(:answer) { create(:answer, author: other_user, question: question) }

      context 'can best' do
        it { should be_able_to :assigning_as_best, answer , author: user}
      end

      context 'cannot make best' do
        before do
          answer.assign_best
        end

        it { should_not be_able_to :assigning_as_best, answer , author: user}
      end
    end

  context 'vote' do
      let(:other_question) { create(:question, author: other_user) }
      let(:question) { create(:question, author: user) }
      let(:other_answer) { create(:answer, author: other_user, question: question) }
      let(:answer) { create(:answer, author: user, question: question) }


      context 'create_like' do
        it { should be_able_to :create_like, other_question, user: user }
        it { should_not be_able_to :create_like, question, user: user }
        it { should_not be_able_to :create_like, other_question.like(user), user: user }

        it { should be_able_to :create_like, other_answer, author: user }
        it { should_not be_able_to :create_like, answer, user: user }
        it { should_not be_able_to :create_like, other_answer.like(user), user: user }
      end

      context 'create_dislike' do
        it { should be_able_to :create_dislike, other_question, author: user }
        it { should_not be_able_to :create_dislike, question, user: user }
        it { should_not be_able_to :create_dislike, other_question.dislike(user), user: user }

        it { should be_able_to :create_dislike, other_answer, user: user }
        it { should_not be_able_to :create_dislike, answer, user: user }
        it { should_not be_able_to :create_dislike, other_answer.dislike(user), user: user }
      end

      context 'deselecting' do
        context 'user can un rating ' do
          before do
            other_question.dislike(user)
            other_answer.dislike(user)
          end

          it { should be_able_to :delete_vote, other_question, user: user }
          it { should_not be_able_to :delete_vote, question, user: user }
          it { should be_able_to :delete_vote, other_answer, user: user }
          it { should_not be_able_to :delete_vote, answer, user: user }
        end
      end
    end
  end
end
