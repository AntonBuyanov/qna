class QuestionsController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  after_action :publish_question, only: [:create]

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answers = @question.answers
    @best_answer = @question.best_answer
    @other_answers = @question.answers.where.not(id: @question.best_answer_id)
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
    if current_user.author?(@question)
      @question.update(question_params)
    end
  end

  def destroy
    if current_user.author?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Your question successfully delete.'
    else
      redirect_to @question, notice: 'Only the author can delete this question'
    end
  end

  private

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question_for_channel',
        locals: { question: @question }
      )
    )
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
    gon.question_id = @question.id
    gon.user_id = current_user.id if current_user
  end

  def question_params
    params.require(:question).permit(:title, :body, :author_id, files: [],
                                     links_attributes: [:id, :name, :url, :_destroy],
                                     badge_attributes: [:name, :image])
  end
end
