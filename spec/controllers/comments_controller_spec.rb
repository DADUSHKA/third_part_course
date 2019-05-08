RSpec.describe CommentsController, type: :controller do

 let(:user) { create(:user) }
 let!(:question) { create(:question) }
 let!(:answer) { create(:answer) }
 let(:create_commit_question) { post :create, params: { question_id: question.id,
          comment: attributes_for(:comment)}, format: :js }
 let(:create_commit_answer) { post :create, params: { answer_id: answer.id,
          comment: attributes_for(:comment)}, format: :js }

 describe 'POST #create' do
  describe 'with authenticated user' do
    before { log_in(user) }

    context 'with valid attributes' do
      it 'save comment for question in database' do
        expect { create_commit_question }.to change(question.comments, :count).by(1)
      end

      it 'save comment for answer in database' do
        expect { create_commit_answer }.to change(answer.comments, :count).by(1)
      end

      it 'new comment has owner' do
        create_commit_question
        expect(assigns(:comment).user).to eq user
      end

      it 'renders create template ' do
        create_commit_answer
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      subject do
        post :create, params: { question_id: question.id, comment: attributes_for(:comment, :invalid),
                      format: :js }
       end

      it 'not save answer in database' do
        expect { subject }.to_not change(question.comments, :count)
      end

      it 're-render create template' do
        subject
        expect(response).to render_template :create
      end
    end
  end

    context "Unauthenticated user" do
      it 'tries create comment' do
        expect { create_commit_question }.to_not change(question.comments, :count)
      end

      it 're-render login page' do
        create_commit_question
        expect(response.body).to eql 'You need to sign in or sign up before continuing.'
      end
    end
  end
end
