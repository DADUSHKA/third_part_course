RSpec.describe Services::Notification do
  let(:question_author) { create(:user) }
  let(:subscribers) { create_list(:user, 3) }
  let(:unsubscribers) { create_list(:user, 2) }

  let(:question) { create(:question, author: subscribers.first) }
  let(:answer_author) { create(:user) }
  let(:answer) { create(:answer, question: question, author: answer_author) }

  after { subject.send_answer(answer) }

  it 'send question notification to question author' do
    expect(NotificationMailer).to receive(:notify).with(subscribers.first, answer).and_call_original
  end

  it 'send question notification for all subscribers' do
    question.subscribe(subscribers[1])
    question.subscribe(subscribers[2])

    subscribers.each do |user|
      expect(NotificationMailer).to receive(:notify).with(user, answer).and_call_original
    end
  end

  it 'do not send question notification to answer author' do
    expect(NotificationMailer).to_not receive(:notify).with(answer_author, answer).and_call_original
  end

  it 'do not send question notification to unsubscribers' do
    unsubscribers.each do |user|
      expect(NotificationMailer).to_not receive(:notify).with(user, answer).and_call_original
    end
  end
end
