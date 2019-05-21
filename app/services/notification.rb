class Services::Notification
  def send_answer(answer)
    answer.question.subscribers.find_each do |user|
      NotificationMailer.notify(user, answer)&.deliver_later unless user.author_of?(answer)
    end
  end
end
