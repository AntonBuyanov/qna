require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }
      let!(:questions) { create_list(:question, 2, author_id: user.id) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question_id: question.id, author_id: user.id) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['author']['id']).to eq question.author.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:question) { create(:question, author_id: user.id) }
    let!(:links) { create_list(:link, 3, linkable: question) }
    let!(:comments) { create_list(:comment, 3, commentable: question, user: user) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    before { get api_path, params: { access_token: access_token.token }, headers: headers }

    it 'contains question fields' do
      %w[id title body created_at updated_at].each do |attr|
        expect(json['question'][attr]).to eq question.send(attr).as_json
      end
    end

    it 'contains question comments files links' do
      %w[comments files links].each do |attr|
        expect(json['question'][attr].size).to eq question.send(attr).size
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    before do
      post api_path, params: {
        access_token: access_token.token,
        question: attributes_for(:question) },
           headers: headers
    end

    it 'return new question' do
      expect(json['question']['body']).to eq 'MyText'
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:question) { create(:question, author_id: user.id) }
    let(:user) { create(:user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    before do
      patch api_path, params: {
        access_token: access_token.token,
        id: question,
        question: { body: 'Edit Body' } },
            headers: headers
    end

    it 'return new question' do
      expect(json['question']['body']).to eq 'Edit Body'
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let!(:question) { create(:question, author_id: user.id) }
    let(:user) { create(:user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    it 'delete the question' do
      expect do
        delete(api_path,
               params: { access_token: access_token.token, id: question },
               headers: headers)
      end.to change(Question, :count).by(-1)
    end
  end
end
