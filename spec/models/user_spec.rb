RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

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
end
