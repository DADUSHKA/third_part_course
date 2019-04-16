RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:author) }
  it { should have_many(:links).dependent(:delete_all) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it 'have many attached file' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end


  describe "set the best answer" do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let!(:answer1) { create(:answer, question: question, author: user) }
    let!(:answer2) { create(:answer, question: question, author: user) }

    it "set the best answer" do
      answer2.assign_best
      expect(answer2).to be_best
    end

    it "resets the best answer" do
      answer1.assign_best
      expect(answer1).to be_best
      answer2.assign_best
      answer1.reload
      expect(answer2).to be_best
      expect(answer1).to_not be_best
    end
  end
end
