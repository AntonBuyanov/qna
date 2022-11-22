require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other_user) { create :user }
    let(:question) { create(:question, author_id: user.id) }
    let(:other_question) { create(:question, author_id: other_user.id) }
    let(:answer) { create(:answer, author_id: user.id) }
    let(:other_answer) { create(:answer, author_id: other_user.id) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, create(:question, author_id: user.id) }
    it { should_not be_able_to :update, create(:question, author_id: other_user.id) }

    it { should be_able_to :update, create(:answer, question: question, author_id: user.id) }
    it { should_not be_able_to :update, create(:answer, question: question, author_id: other_user.id) }
  end
end
