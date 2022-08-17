require 'rails_helper'

describe 'Questions API' do
  let(:do_request) { get '/api/v1/questions' }
  it_behaves_like 'API authenticable'

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
      let(:question) { create(:question_with_file) }
      let(:comments) do
        create_list(:comment, 2, commentable_type: question.class.to_s,
                                 commentable_id: question.id,
                                 user_id: question.user.id)
      end
      let!(:comment) { comments.first }
      let!(:attachment) { question.attachments.first }

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

      it 'contains attachments object' do
        expect(response.body).to be_json_eql(question.attachments.to_json).at_path('attachments')
      end

      context 'attachments' do
        %w[file created_at updated_at attachable_id attachable_type].each do |attr|
          it "object contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("attachments/0/#{attr}")
          end
        end

        it 'contains url to file' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('attachments/0/file/url')
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
      let(:answer) { create(:answer_with_file) }
      let(:comments) do
        create_list(:comment, 2, commentable_type: answer.class.to_s,
                                 commentable_id: answer.id,
                                 user_id: answer.user.id)
      end
      let!(:comment) { comments.first }
      let!(:attachment) { answer.attachments.first }

      before do
        get "/api/v1/questions/#{answer.question.id}/answers/#{answer.id}",
            headers: { 'Authorization': "Bearer #{token.token}" }, as: :json
      end

      it 'returns 200 status code' do
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

      it 'contains attachments object' do
        expect(response.body).to be_json_eql(answer.attachments.to_json).at_path('attachments')
      end

      context 'attachments' do
        %w[file created_at updated_at attachable_id attachable_type].each do |attr|
          it "object contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("attachments/0/#{attr}")
          end
        end

        it 'contains url to file' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('attachments/0/file/url')
        end
      end
    end

    context 'POST /questions'

    context 'POST /questions/:question_id/answers'
  end

  def do_request(params = {})
    get '/api/v1/questions', params
  end
end
