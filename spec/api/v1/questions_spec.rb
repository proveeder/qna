require 'rails_helper'

describe 'Questions API' do
  describe 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      get '/api/v1/questions'
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      get '/api/v1/questions', params: { access_token: '1234' }
      expect(response.status).to eq 401
    end
  end

  let(:token) { create(:access_token) }

  describe 'authorized' do
    let!(:questions) { create_list(:question, 2) }
    let(:question) { questions.first }

    let!(:answers) { create_list(:answer, 2, question: question) }
    let!(:answer) { answers.first }

    context 'GET /questions' do
      before { get '/api/v1/questions', headers: { 'Authorization': "Bearer #{token.token}" }, as: :json }

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2)
      end

      %w[id title body created_at updated_at].each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      it 'question object contains short_title' do
        p response
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path('0/short_title')
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(2).at_path('0/answers')
        end

        %w[id body created_at updated_at].each do |attr|
          it "object contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
          end
        end
      end
    end

    context 'GET /questions/:id' do
      let(:comments) do
        create_list(:comment, 2, commentable_type: question.class.to_s,
                                 commentable_id: question.id,
                                 user_id: question.user.id)
      end
      let!(:comment) { comments.first }


      # TODO: DO FOR FILES
      # let(:attachment) do
      #   create(:attachment, attachable_id: question.id, attachable_type: question.class.to_s)
      # end

      before do
        get "/api/v1/questions/#{question.id}", headers: { 'Authorization': "Bearer #{token.token}" }, as: :json
      end

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end

      %w[id title body created_at updated_at].each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      it 'contains comments object' do
        expect(response.body).to be_json_eql(question.comments.to_json).at_path('comments')
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(2).at_path('comments')
        end

        %w[text commentable_type commentable_id created_at updated_at user_id].each do |attr|
          it "object contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end
    end

    context 'GET /questions/:question_id/answers' do
      before do
        get "/api/v1/questions/#{question.id}/answers", headers: { 'Authorization': "Bearer #{token.token}" }, as: :json
      end

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end

      it 'contains answers' do
        expect(response.body).to be_json_eql(question.answers.to_json).at_path('answers')
      end

      %w[id body question_id created_at updated_at user_id].each do |attr|
        it "object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end

    context 'GET /questions/:question_id/answers/:id' do
      let(:comments) do
        create_list(:comment, 2, commentable_type: answer.class.to_s,
                    commentable_id: answer.id,
                    user_id: answer.user.id)
      end
      let!(:comment) { comments.first }

      # TODO: DO FOR FILES
      # let(:attachment) do
      #   create(:attachment, attachable_id: question.id, attachable_type: question.class.to_s)
      # end

      before do
        get "/api/v1/questions/#{answer.question.id}/answers/#{answer.id}",
            headers: { 'Authorization': "Bearer #{token.token}" }, as: :json
      end

      it 'returns 200 status code' do
        p response.body
        expect(response.status).to eq 200
      end

      %w[id body question_id created_at updated_at user_id].each do |attr|
        it "object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path(attr.to_s)
        end
      end

      it 'contains comments object' do
        expect(response.body).to be_json_eql(answer.comments.to_json).at_path('comments')
      end

      context 'comments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(2).at_path('comments')
        end

        %w[text commentable_type commentable_id created_at updated_at user_id].each do |attr|
          it "object contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end
    end

    context 'POST /questions'

    context 'POST /questions/:question_id/answers'
  end
end
