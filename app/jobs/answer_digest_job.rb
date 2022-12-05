class AnswerDigestJob < ApplicationJob
  queue_as :default

  def perform(answer)
    AnswerDigest.new(answer).send_digest
  end
end
