class AnswerDigestMailer < ApplicationMailer
  def digest(user, answer)
    @answer = answer

    mail to: user.email
  end
end
