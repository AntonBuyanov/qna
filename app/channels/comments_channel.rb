class CommentsChannel < ApplicationCable::Channel
  def follow
    stream_from "comment_#{params[:question_id]}"
  end
end
