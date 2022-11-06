module Voted
  extend ActiveSupport::Concern

  included do
    RATING ||= { like: 1, dislike: -1 }.freeze

    before_action :set_votable, only: %i[like dislike cancel]
  end

  def like
    voted(RATING[:like])
  end

  def dislike
    voted(RATING[:dislike])
  end

  def cancel
    @votable.votes.where(user_id: current_user.id).first.destroy

    render_json
  end

  private

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end

  def voted(value)
    current_user.vote(@votable, value)
    render_json
  end

  def render_json
    render json: { rating: @votable.rating, votable_id: @votable.id, votable_name: @votable.class.name.downcase }
  end
end
