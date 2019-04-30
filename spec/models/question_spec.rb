RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:delete_all) }
  it { should have_many(:links).dependent(:delete_all) }
  it { should have_one(:award).dependent(:destroy)  }
  it { should belong_to(:author) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :award }

  it 'have many attached file' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'voteable' do
    let(:user) { create(:user) }
    let(:question) {create :question, author: user }

    it_behaves_like 'voteable', 'question'
  end

  describe 'commentable' do
    it_behaves_like 'has many comments'
  end
end
