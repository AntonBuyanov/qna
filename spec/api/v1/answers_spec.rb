require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/answers/:id' do
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:user) { create(:user) }
    let(:question) { create(:question, author_id: user.id) }
    let(:answer) { create(:answer, question_id: question.id, author_id: user.id) }
    let(:comments) { create_list(:comment, commentable: answer, user: user) }
    let(:links) { create_list(:link, linkable: answer) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    before { get api_path, params: { access_token: access_token.token }, headers: headers }

    context 'authorized' do
      it 'contains answer fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(json['answer'][attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains answer comments files links' do
        %w[comments files links].each do |attr|
          expect(json['answer'][attr].size).to eq answer.send(attr).size
        end
      end
    end
  end

  describe 'POST /api/v1/question/:id/answers/' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let!(:question) { create(:question, author_id: user.id) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    before do
      post api_path, params: {
        access_token: access_token.token,
        question_id: question.id,
        answer: attributes_for(:answer) },
           headers: headers
    end

    it 'return new answer' do
      expect(json['answer']['body']).to eq 'MyString'
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author_id: user.id) }
    let(:answer) { create(:answer, question_id: question.id, author_id: user.id) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    before do
      patch api_path, params: {
        access_token: access_token.token,
        answer: { body: 'Edit Body' } },
            headers: headers
    end

    it 'return new question' do
      expect(json['answer']['body']).to eq 'Edit Body'
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author_id: user.id) }
    let!(:answer) { create(:answer, question_id: question.id, author_id: user.id) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    it 'delete the answer' do
      expect do
        delete(api_path,
               params: { access_token: access_token.token, id: answer },
               headers: headers)
      end.to change(Answer, :count).by(-1)
    end
  end
end
