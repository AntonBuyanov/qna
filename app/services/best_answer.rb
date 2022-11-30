class BestAnswer
  attr_reader :answer, :question

  def initialize(answer)
    @answer = answer
    @question = answer.question
  end

  def call
    question.badge.user = question.author if question.badge
    question.update(best_answer_id: answer.id)
    question.save
  end
end
