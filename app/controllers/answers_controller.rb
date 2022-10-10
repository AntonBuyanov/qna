class AnswersController < ApplicationController

  before_action :authenticate_user!, except: :show
  before_action :find_question, only: %i[new create]
  before_action :load_answer, only: %i[show destroy]

  def new
    @answer = @question.answers.new
  end

  def show ;end

  def create
    @answer = @question.answers.build(answer_params)

    if @answer.save
      redirect_to @answer, notice: 'Your answer successfully created.'
    else
      render :new
    end
  end

  def destroy
    if current_user.author?(@answer)
      @answer.destroy
      redirect_to questions_path, notice: 'Your answer successfully delete.'
    else
      redirect_to @answer, notice: 'Only the author can delete this question'
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
