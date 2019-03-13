require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }

  describe 'POST #create' do

    context 'with valid attributes' do
      let(:action) { post :create, params: { question_id: question.id,
       answer: attributes_for(:answer) } }

      it 'saves the new answer' do
        expect { action }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        action
        expect(response).to redirect_to assigns(:answer)
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
        expect(response).to render_template :new
      end
    end
  end

end
