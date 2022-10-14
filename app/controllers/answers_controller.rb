class AnswersController < ApplicationController

  before_action :authenticate_user!, except: :show
  before_action :find_question, only: %i[new create]
  before_action :load_answer, only: %i[show destroy update set_best]

  def new
    @answer = @question.answers.new
  end

  def show ;end

  def create
    @answer = @question.answers.create(answer_params)
  end

  def update
    if current_user.author?(@answer)
      @answer.update(answer_params)
    end

    @question = @answer.question
  end

  def set_best
    @answer.mark_as_best if current_user.author?(@answer.question)
    @question = @answer.question
    @question.save
  end

  def destroy
    @answer.destroy if current_user.author?(@answer)
    @question = @answer.question
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body).merge(author: current_user)
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
