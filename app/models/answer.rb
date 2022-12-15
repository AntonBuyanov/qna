class Answer < ApplicationRecord
  include Votable
  include Commentable

  has_many_attached :files, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable

  belongs_to :question, touch: true
  belongs_to :author, class_name: 'User'

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  after_save :answer_digest

  private

  def answer_digest
    AnswerDigestJob.perform_later(self)
  end
end
