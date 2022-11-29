require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question, author_id: user.id) }
  let!(:answer) { attributes_for(:answer, question: question, author_id: user.id) }
  let!(:user) { create(:user) }

  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer).merge(author_id: user.id), question_id: question }, format: :json }.to change(Answer, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: { question_id: question, answer: answer, format: :json }
        expect(response).to render_template 'answers/_answer_for_channel'
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :json } }.to_not change(question.answers, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :json }
        expect(response).to_not render_template 'answers/_answer_for_channel'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, author_id: user.id, question: question) }

    before { login(user) }
    it 'deletes the answer' do
      expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, author_id: user.id, question: question) }

    before { login(user) }
    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end
end
