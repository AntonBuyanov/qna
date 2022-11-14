class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: :show
  before_action :find_question, only: %i[new create]
  before_action :load_answer, only: %i[show destroy update set_best]

  after_action :publish_answer, only: [:create]

  def new
    @answer = @question.answers.new
  end

  def show ;end

  def create
    @answer = @question.answers.new(answer_params)

    respond_to do |format|
      if @answer.save
        format.json { render json: @answer }
      else
        format.json do
          render json: @answer.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
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

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "answer_#{params[:question_id]}",
      ApplicationController.render(
        partial: 'answers/answer_for_channel',
        locals: { answer: @answer}
      )
    )
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [],
                                   links_attributes: [:id, :name, :url, :_destroy]).merge(author: current_user)
  end

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end
end
