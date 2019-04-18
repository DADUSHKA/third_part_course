RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:user1) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe "GET #index" do
    let(:questions) { create_list(:question_s, 2) }
    before { get :index }
    it "populates an array of all questions" do
      expect(assigns(:questions)).to match_array(questions)
    end

    it "renders index view" do
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    before { get :show, params: { id: question } }

    it "assigns request question to @question" do
      expect(assigns(:question)).to eq question
    end

    it "renders show view" do
      expect(response).to render_template :show
    end

    it "assigns new answer for question" do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end
  end

  describe "GET #new" do
    before { log_in(user) }

    before { get :new }

    it 'assigns a new Link to @question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it "renders new view" do
      expect(response).to render_template :new
    end
  end

  describe "GET #edit" do
    before { log_in(user) }

    before { get :edit, params: { id: question }, format: :js }

    it "renders edit view" do
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    before { log_in(user) }

    context "with valid attributes" do
      let(:action) { post :create, params: { question: attributes_for(:question) } }

      it "saves a new question in the database" do
        expect { action }.to change(Question, :count).by(1)
      end

      it "check connection with logged-in user" do
        action
        expect(assigns(:question).author).to eq user
      end

      it "redirects to show view" do
        action
        expect(response).to redirect_to assigns(:question)
      end
    end

    context "with invalid attributes" do
      let(:action) { post :create, params: { question: attributes_for(:question, :invalid) } }

      it "does not save the question" do
        expect { action }.to_not change(Question, :count)
      end

      it "re-renders new view" do
        action
        expect(response).to render_template :new
      end
    end
  end

  describe "PATCH #update" do
    before { log_in(user) }

    context "with valid attributes" do
      it "assigns the requested question to @question" do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(assigns(:question)).to eq question
      end

      it "changes question attributes" do
        patch :update, params: { id: question, question: { title: "new title", body: "new body" }, format: :js }
        question.reload

        expect(question.title).to eq "new title"
        expect(question.body).to eq "new body"
      end

      it "non-author changes question attributes" do
        log_in(user1)
        patch :update, params: { id: question, question: { title: "new title", body: "new body" }, format: :js }
        question.reload

        expect(question.title).not_to eq "new title"
        expect(question.body).not_to eq "new body"
      end

      it "redirects to updated question" do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(response).to render_template :update
      end
    end

    context "with invalid attributes" do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

      it "does not change question" do
        question.reload

        expect(question.title).to eq "MyQuestion"
        expect(question.body).to eq "MyText"
      end

      it "re-renders edit view" do
        expect(response).to render_template :update
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:question) { create(:question) }
    let(:delete_action) { delete :destroy, params: { id: question } }

    context "if question belongs to the user" do
      before { sign_in(question.author) }
      it "deletes question" do
        expect { delete_action }.to change(Question, :count).by(-1)
      end

      it "redirects to questions index" do
        delete_action
        expect(response).to redirect_to questions_path
      end
    end

    context "if question does not belong to the user" do
      let(:user) { create(:user) }

      before do
        sign_in(user)
      end

      it "does not delete question" do
        expect { delete_action }.to_not change(Question, :count)
      end

      it "redirects to question#show" do
        delete_action
        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
