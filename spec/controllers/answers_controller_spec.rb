RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    before { log_in(user) }

    context 'with valid attributes' do
      let(:action) { post :create, params: { question_id: question.id,
       answer: attributes_for(:answer), format: :js } }

      it 'check connection with logged-in user' do
        action
        expect(assigns(:answer).author).to eq user
      end

      it 'saves the new answer' do
        expect { action }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        action
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      let(:action) { post :create, params: { question_id: question.id,
       answer: attributes_for(:answer, :invalid) }, format: :js }

       it 'does not save the new answer' do
        expect { action }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        action
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question) }
    let(:delete_action) { delete :destroy, params: {id: answer} }

    before { sign_in(answer.author) }

    context 'delete answer' do
      it 'delete answer from database' do
        expect { delete_action }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question show' do
        delete_action
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'if answer does not belong to the user' do
      let!(:user) { create(:user) }

      before { sign_in(user) }

      it 'does not delete answer' do
        expect { delete_action }.to_not change(Answer, :count)
      end

      it 'redirects to question#show' do
        delete_action
        expect(response).to redirect_to question_path(answer.question)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question) }
    before { sign_in(answer.author) }

    context 'with valid attributes' do
      let(:action) { patch :update, params: { id: answer,
       answer: { body: 'new body' } }, format: :js }

      it 'changes answer attributes' do
        action
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        action
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      let(:action) { patch :update, params: { id: answer,
       answer: attributes_for(:answer, :invalid) }, format: :js }

      it 'does not change answer attributes' do
        expect { action }.to_not change(answer, :body)
      end

      it 'renders update view' do
        action
        expect(response).to render_template :update
      end
    end
  end
end
