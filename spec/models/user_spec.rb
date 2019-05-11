RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:awards) }
  it { should have_many(:votes) }
  it { should have_many(:comments) }
  it { should have_many(:authorizations).dependent(:destroy) }

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

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context "user already has authorization" do
      it "return the user" do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context "user has not authorization" do
      context "user already exists" do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }
        it 'does not create new user' do
          expect{ User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect{ User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          user = User.find_for_oauth(auth)
          authorization = user.authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'return user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user has not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' }) }

        it 'create new user' do

        end

        it 'return user' do

        end

        it 'fill user email' do

        end

        it 'create authorization for user' do

        end

        it 'create authorization with provider and uid' do

        end
      end
    end
  end
end
