shared_examples_for 'voteable' do |voteable|
  let(:resource) { send(voteable) }
  let(:other_user) { create(:user) }

  it { should have_many(:votes).dependent(:delete_all) }

  describe 'like not owner resource' do
    before do
      resource.like(other_user)
    end

    it { expect(Vote.last.choice).to eq 1 }
    it { expect(Vote.last.user.id).to eq other_user.id }
    it { expect(Vote.last.voteable_id).to eq resource.id }
  end

  describe 'like owner resource' do

    it { expect { resource.like(user) }.to change(Vote, :count).by(0) }
  end

  describe 'repeat voting like' do
    before do
      resource.like(other_user)
      resource.like(other_user)
    end

    it { expect(Vote.last.choice).to_not eq 2 }
  end

  describe 'dislike not owner resource' do
    before do
      resource.dislike(other_user)
    end

    it { expect(Vote.last.choice).to eq -1 }
    it { expect(Vote.last.user.id).to eq other_user.id }
    it { expect(Vote.last.voteable_id).to eq resource.id }
  end

  describe 'dislike owner resource' do
    it { expect { resource.like(user) }.to change(Vote, :count).by(0) }
  end

  describe 'repeat voting dislike' do
    before do
      resource.dislike(other_user)
      resource.dislike(other_user)
    end

    it { expect(Vote.last.choice).to_not eq -2 }
  end

  describe 'deselecting vote owner rating' do
    before do
      resource.like(other_user)
      resource.deselecting(other_user)
    end

    it { expect(Vote.last).to eq nil }
  end

  describe 'votings' do
    let(:users1) { create_list :user, 3 }
    let(:users2) { create_list :user, 2 }

    before do
      (0..2).each { |i| resource.like(users1[i]) }
      (0..1).each { |i| resource.dislike(users2[i]) }
    end

    it { expect(resource.choice).to eq 1 }
  end
end
