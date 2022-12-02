require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author_id: user.id) }

  before { login(user) }

  describe 'POST#create' do
    it 'saves a new subscribe in the database' do
      expect { post :create, params: { question_id: question.id, format: :js } }.to change(Subscription, :count).by(1)
    end
  end

  describe 'DELETE#destroy' do
    let!(:subscription) { create(:subscription, user_id: user.id, question_id: question.id) }

    it 'destroy subscribe in the database' do
      expect { delete :destroy, params: { id: subscription, format: :js } }.to change(Subscription, :count).by(-1)
    end
  end
end
