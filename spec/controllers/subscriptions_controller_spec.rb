RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let(:create_subscribe_request) { post :create, params: { question_id: question } }

  before { log_in(other_user) }

  describe 'POST #create' do
    it 'subscribe to question' do
      expect { create_subscribe_request }.to change(question.subscriptions, :count).by(1)
    end

    it 'redirects to question show view' do
      create_subscribe_request
      expect(response).to redirect_to assigns(:question)
    end
  end

  describe 'DELETE #destroy' do
    it 'other user unsubscribes from question' do
      create_subscribe_request

      expect do
        delete :destroy, params: { id: question.subscriptions.find_by(user: other_user) }
      end.to change(question.subscriptions, :count).by(-1)
    end

    it 'question author unsubscribes from question' do
      expect do
        delete :destroy, params: { id: question.subscriptions.find_by(user: user) }
      end.to change(question.subscriptions, :count).by(-1)
    end

    it 'redirects to question show view' do
      create_subscribe_request
      expect(response).to redirect_to assigns(:question)
    end
  end
end
