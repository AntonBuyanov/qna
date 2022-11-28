class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :find_question, only: %i[show update destroy]

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: @question
  end

  def create
    @question = Question.new(question_params)
    @question.author = current_resource_owner

    if @question.save
      render json: @question
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params)
      render json: @question
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
