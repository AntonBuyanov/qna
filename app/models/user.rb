class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:github, :vkontakte]

  has_many :questions, class_name: 'Question', foreign_key: :author_id
  has_many :answers, class_name: 'Answer', foreign_key: :author_id
  has_many :badges, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  def author?(resource)
    resource.author_id == id
  end

  def vote(resource, value)
    votes.create(votable: resource, value: value)
  end

  def self.find_for_oauth(auth)
    FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def self.create_by(email)
    password = Devise.friendly_token[0, 20]
    User.create(email: email, password: password, password_confirmation: password)
  end
end
