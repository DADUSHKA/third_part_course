RSpec.describe NotificationJob, type: :job do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }
  let(:service) { double('Service::Notification') }

  before do
    allow(Services::Notification).to receive(:new).and_return(service)
  end

  it 'calls Services::Notification#send_answer' do
    expect(service).to receive(:send_answer).with(answer)
    NotificationJob.perform_now(answer)
  end
end
