shared_examples_for 'voteable' do |voteable|
  let(:resource) { send(voteable) }
  let(:other_user) { create(:user) }

  it { should have_many(:votes).dependent(:delete_all) }

  describe 'like not owner resource' do
    before do
      resource.like(other_user)
    end

    it { expect(Vote.last.choice).to eq 1 }
  end

  describe 'like owner resource' do
    before do
      resource.like(user)
    end

    it { expect(Vote.last).to eq nil }
  end

  describe 'repeat voting like' do
    before do
      resource.like(other_user)
      resource.like(other_user)
    end

    it { expect(Vote.last.choice).to eq 1 }
  end

  describe 'dislike not owner resource' do
    before do
      resource.dislike(other_user)
    end

    it { expect(Vote.last.choice).to eq -1 }
  end

  describe 'dislike owner resource' do
    before do
      resource.dislike(user)
    end

    it { expect(Vote.last).to eq nil }
  end

  describe 'repeat voting dislike' do
    before do
      resource.dislike(other_user)
      resource.dislike(other_user)
    end

    it { expect(Vote.last.choice).to eq -1 }
  end

  describe 'deselecting vote owner rating' do
    before do
      resource.like(other_user)
      resource.deselecting(other_user)
    end

    it { expect(Vote.last).to eq nil }
  end

  describe 'votings' do
    let(:users) { create_list :user, 5 }

    before do
      (0..4).each { |i| resource.like(users[i]) }
    end

    it { expect(resource.choice).to eq 5 }
  end
end
