class AnswerDigest
  def initialize(answer)
    @answer = answer
    @question = answer.question
  end

  def send_digest
    @question.subscriptions.find_each(batch_size: 500) do |subscribe|
      AnswerDigestMailer.digest(subscribe.user, @answer).deliver_later
    end
  end
end
