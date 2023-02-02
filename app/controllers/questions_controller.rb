class QuestionsController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :find_subscription, only: [:show, :update]

  after_action :publish_question, only: [:create]

  authorize_resource

  def index
    @questions = Question.order(updated_at: :desc)
  end

  def show
    @answer = Answer.new
    @other_answers = @question.answers.where.not(id: @question.best_answer_id)
    @answers = @question.answers
    @best_answer = @question.best_answer
    @answer.links.new
  end

  def new
    @question = Question.new
    @question.links.new
    @question.build_badge
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Your question successfully delete.'
  end

  private

  def publish_question
    return if @question.errors.any?

    ApplicationController.renderer.instance_variable_set(
      :@env, {
      "warden" => warden
    }
    )

    ActionCable.server.broadcast(
      'questions',
      {
        partial: ApplicationController.render(
          partial: 'questions/question',
          locals: { question: @question }
        )
      }
    )
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
    gon.question_id = @question.id
  end

  def question_params
    params.require(:question).permit(:title, :body, :author_id, files: [],
                                     links_attributes: [:id, :name, :url, :_destroy],
                                     badge_attributes: [:name, :image])
  end

  def find_subscription
    @subscription = @question.subscriptions.find_by(user: current_user)
  end
end
