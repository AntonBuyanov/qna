module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: %i[comment]
    after_action :publish_comment, only: %i[comment]
  end

  def comment
    @comment = @commentable.comments.create!(user: current_user,
                                             body: comment_params[:body])
  end

  private

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
      "comment_#{set_resource}", {
      partial: ApplicationController.render(
        partial: 'comments/comment_for_channel',
        locals: { comment: @comment }
      ),
      resource_type: @comment.commentable_type,
      resource_id: @commentable.id
      }
    )
  end

  def set_resource
    @commentable.is_a?(Question) ? @commentable.id : @commentable.question.id
  end

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
