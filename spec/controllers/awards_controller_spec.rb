RSpec.describe AwardsController, type: :controller do

  describe "GET #index" do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:awards) { create_list(:award,2, question: question, user: user) }

    before { log_in(user) }
    before { get :index }

    it "populates an array of all rewards of user" do
      expect(assigns(:awards)).to match_array(awards)
    end

    it "renders index view" do
      expect(response).to render_template :index
    end
  end
end


