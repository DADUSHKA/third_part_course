RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:awards) }
  it { should have_many(:votes) }

  describe "Author_of?" do
    let!(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:users_question) { create(:question, author_id: user.id) }

    it "user is the author of the question" do
      expect(user).to be_author_of(users_question)
    end

    it "user is not author of the question" do
      expect(user).to_not be_author_of(question)
    end
  end

  describe "Voted?" do
    let(:not_voted_user) { create(:user) }
    let(:voted_user) { create(:user) }
    let(:author_reply) { create(:user) }

    let(:answer) { create(:answer, author: author_reply) }
    let(:vote) { create(:vote, user_id: voted_user.id, voteable: answer) }
    let(:votes) {[]}

    it "user is the author of the vote" do
      votes << vote
      expect(voted_user).to be_voted(answer)
    end

     it "user is not author of the vote" do
      votes << vote
      expect(not_voted_user).to_not be_voted(answer)
    end
  end
end
