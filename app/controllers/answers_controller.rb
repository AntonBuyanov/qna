class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: :show
  before_action :find_question, only: %i[new create]
  before_action :load_answer, only: %i[show destroy update set_best]

  after_action :publish_answer, only: [:create]

  authorize_resource

  def new
    @answer = @question.answers.new
  end

  def show; end

  def create
    @answer = @question.answers.create(answer_params)
  end

  def update
    @answer.update(answer_params)
  end

  def set_best
    BestAnswer.new(@answer).call
  end

  def destroy
    @answer.destroy
  end

  private

  def publish_answer
    return if @answer.errors.any?

    ApplicationController.renderer.instance_variable_set(
      :@env, {
      "warden" => warden
    }
    )

    ActionCable.server.broadcast(
      "answer_#{params[:question_id]}",
      {
        author_id: @answer.author.id,
        partial: ApplicationController.render(
          partial: 'answers/answer',
          locals: { answer: @answer },
        )
      }
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
