require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    before { log_in(user) }

    context 'with valid attributes' do
      let(:action) { post :create, params: { question_id: question.id,
       answer: attributes_for(:answer) } }

      it 'check connection with logged-in user' do
        action
        expect(assigns(:answer).author).to eq user
      end

      it 'saves the new answer' do
        expect { action }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        action
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      let(:action) { post :create, params: { question_id: question.id,
       answer: attributes_for(:answer, :invalid) } }

       it 'does not save the new answer' do
        expect { action }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        action
        expect(response).to render_template 'questions/show'
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
end
