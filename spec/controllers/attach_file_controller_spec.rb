RSpec.describe AttachFileController, type: :controller do
  let(:user) { create(:user) }
  let(:user1) { create(:user) }

  describe "DELETE #destroy" do
    let!(:question) { create(:question, :with_file, author: user) }
    let!(:answer) { create(:answer, :with_file, author: user1) }
    let(:delete_action_question) { delete :destroy, params: { id: question.files.first.id }, format: :js }
    let(:delete_action_answer) { delete :destroy, params: { id: answer.files.first.id }, format: :js }

    context "deleting an attached file belongs to the user" do
      before do
        sign_in(user)
      end

      it "for the question" do
        expect { delete_action_question }.to change { ActiveStorage::Attachment.count }.by(-1)
      end

      it "re-renders new view answer" do
        delete_action_answer
        expect(response).to render_template :destroy
      end
    end

    context "deleting an attached file does not belong to the user" do
      before do
        sign_in(user)
      end

      it "for the answer" do
        expect { delete_action_answer }.to_not change { ActiveStorage::Attachment.count }
      end
    end
  end
end
