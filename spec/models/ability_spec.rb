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
    let(:answer) { create(:answer, question: question, author_id: user.id) }
    let(:other_answer) { create(:answer, question: question, author_id: other_user.id) }
    let(:link) { create(:link, linkable: question) }

    context 'all read, not manage' do
      it { should_not be_able_to :manage, :all }
      it { should be_able_to :read, :all }
    end

    context 'create' do
      it { should be_able_to :create, Question }
      it { should be_able_to :create, Answer }
      it { should be_able_to :create, Comment }
      it { should be_able_to :create, Subscription }
    end

    context 'update destroy' do
      it { should be_able_to [:update, :destroy], question }
      it { should_not be_able_to [:update, :destroy], other_question }

      it { should be_able_to [:update, :destroy], answer }
      it { should_not be_able_to [:update, :destroy], other_answer }
    end

    context 'set best answer' do
      it { should be_able_to :set_best, answer }
      it { should_not be_able_to :set_best, other_answer }
    end

    context 'link' do
      it { should be_able_to :destroy, create(:link, linkable: question) }
      it { should_not be_able_to :destroy, create(:link, linkable: other_question) }
    end

    context 'voted' do
      it { should be_able_to [:like, :dislike, :cancel], other_question }
      it { should_not be_able_to [:like, :dislike, :cancel], question }

      it { should be_able_to [:like, :dislike, :cancel], other_answer }
      it { should_not be_able_to [:like, :dislike, :cancel], answer }
    end

    context 'comment' do
      it { should be_able_to :comment, question }
      it { should be_able_to :comment, answer }
    end

    context 'subscribe' do
      it { should be_able_to [:create, :destroy], Subscription }
    end
  end
end
