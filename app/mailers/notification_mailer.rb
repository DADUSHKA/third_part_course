class NotificationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.notify.subject
  #
  def notify(user, answer)
   @answer = answer
   @question = answer.question
   @owner = answer.user
  end
end
