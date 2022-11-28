class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at
  has_one :question
  has_many :comments
  has_many :links
  has_many :files
  belongs_to :author
end
