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

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :correct)
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
