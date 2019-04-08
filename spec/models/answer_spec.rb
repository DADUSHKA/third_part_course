RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:author) }

  it { should validate_presence_of :body }

  describe "set the best answer" do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let!(:answer1) { create(:answer, question: question, author: user) }
    let!(:answer2) { create(:answer, question: question, author: user) }

    it "set the best answer" do
      answer2.assign_best
      expect(question.answers[0]).to eq answer2
      expect(answer2.best).to eq true
    end

    it "resets the best answer" do
      answer1.assign_best
      expect(answer1.best).to eq true
      answer2.assign_best
      expect(answer2.best).to eq true
      expect(answer2).to be_best
    end
  end
end
