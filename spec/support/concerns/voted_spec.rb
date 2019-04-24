shared_examples_for 'voted' do |voteable|
  let(:resource) { send(voteable) }
  let(:other_user) {create(:user) }

  describe 'POST #create_like' do
    describe 'with authenticated user not owner voteable' do
      before do
        log_in(other_user)
      end

      subject do
        post :create_like, params: { id: resource, format: :json }
      end

      it { expect {subject}.to change(Vote, :count).by(1) }

      it 'render json' do
        subject
        expect(response.body).to eq "{\"choice\":1,\"id\":#{resource.id},\"klass\":\"#{resource.class.to_s}\"}"
      end

      it 'rating' do
        subject
        expect(resource.choice).to eq 1
      end
    end
  end

  describe 'POST #create_dislike' do
    describe 'with authenticated user not owner voteable' do
      before { log_in(other_user) }

      subject do
        post :create_dislike, params: { id: resource, format: :json }
      end

      it { expect {subject}.to change(Vote, :count).by(1) }

      it 'render json' do
        subject
        expect(response.body).to eq "{\"choice\":-1,\"id\":#{resource.id},\"klass\":\"#{resource.class.to_s}\"}"
      end

      it 'rating' do
        subject
        expect(resource.choice).to eq -1
      end
    end
  end

  describe 'POST #delete_vote' do
    describe 'with authenticated user not owner voteable' do
      let!(:vote) { create :vote, voteable: resource, user: other_user }

      before { log_in(other_user) }

      subject do
        delete :delete_vote, params: { id: resource, format: :json }
      end

      it { expect {subject}.to change(Vote, :count).by(-1) }

      it 'render json' do
        subject
        expect(response.body).to eq "{\"choice\":0,\"id\":#{resource.id},\"klass\":\"#{resource.class.to_s}\"}"
      end

      it 'rating' do
        subject
        expect(resource.choice).to eq 0
      end
    end
  end
end

