require "rails_helper"

RSpec.describe AttachFileController, type: :controller do
  let(:user) { create(:user) }

  describe "DELETE #destroy" do
    let!(:question) { create(:question, :with_file) }
    let!(:answer) { create(:answer, :with_file) }
    let(:delete_action_question) { delete :destroy, params: { id: question.files.first.id }, format: :js }
    let(:delete_action_answer) { delete :destroy, params: { id: answer.files.first.id }, format: :js }

    context "deleting an attached file" do
      before do
        sign_in(user)
      end

      it "for the question" do
        expect { delete_action_question }.to change { ActiveStorage::Attachment.count }.by(-1)
      end

      it "re-renders new view question" do
        delete_action_question
        expect(response).to render_template :destroy
      end

      it "for the answer" do
        expect { delete_action_answer }.to change { ActiveStorage::Attachment.count }.by(-1)
      end

      it "re-renders new view answer" do
        delete_action_answer
        expect(response).to render_template :destroy
      end
    end
  end
end
