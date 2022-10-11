class AnswersController < ApplicationController

  before_action :authenticate_user!, except: :show
  before_action :find_question, only: %i[new create]
  before_action :load_answer, only: %i[show destroy]

  def new
    @answer = @question.answers.new
  end

  def show ;end

  def create
    @answer = @question.answers.create(answer_params)
  end

  def destroy
    @question = @answer.question
    if current_user.author?(@answer)
      @answer.destroy
      redirect_to @question, notice: 'Your answer successfully delete.'
    else
      redirect_to @question, notice: 'Only the author can delete this question'
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :correct).merge(author: current_user)
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
