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

    context 'POST /questions/:question_id/answers' do
      context 'user is allowed to do that' do
        context 'with valid attrs' do
          it 'creates new answer' do
            expect do
              post "/api/v1/questions/#{question.id}/answers", headers: { 'Authorization': "Bearer #{token.token}" },
                                                               params: { answer: { body: 'Some question body',
                                                                                   question_id: question.id,
                                                                                   user_id: create(:user).id } },
                                                               as: :json
            end.to change(Answer, :count).by(1)
          end

          it 'returns 200 status code' do
            post "/api/v1/questions/#{question.id}/answers", headers: { 'Authorization': "Bearer #{token.token}" },
                                                             params: { answer: { body: 'Some question body',
                                                                                 question_id: question.id,
                                                                                 user_id: create(:user).id } },
                                                             as: :json
            expect(response.status).to eq 200
          end
        end

        context 'with invalid args' do
          before do
            post "/api/v1/questions/#{question.id}/answers", headers: { 'Authorization': "Bearer #{token.token}" },
                                                             params: { answer: { body: nil,
                                                                                 question_id: nil,
                                                                                 user_id: nil } },
                                                             as: :json
          end

          it 'returns question errors' do
            expect(response.body).to be_json_eql("{\"body\":[\"can't be blank\"],
                                                  \"user_id\":[\"can't be blank\"],
                                                  \"user\":[\"must exist\"]}")
          end

          it 'returns 500 internal server error' do
            expect(response.status).to eq 500
          end
        end
      end
    end
  end
end
