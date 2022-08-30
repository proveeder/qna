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

    context 'POST /questions' do
      context 'user is allowed to do that' do
        context 'with valid attrs' do
          it 'creates new question' do
            expect do
              post '/api/v1/questions', headers: { 'Authorization': "Bearer #{token.token}" },
                                        params: { question: { title: 'Some question title',
                                                              body: 'Some question body',
                                                              user_id: create(:user).id } },
                                        as: :json
            end.to change(Question, :count).by(1)
          end

          it 'returns 200 status code' do
            post '/api/v1/questions', headers: { 'Authorization': "Bearer #{token.token}" },
                                      params: { question: { title: 'Some question title',
                                                            body: 'Some question body',
                                                            user_id: create(:user).id } },
                                      as: :json
            expect(response.status).to eq 200
          end
        end

        context 'with invalid args' do
          before do
            post '/api/v1/questions', headers: { 'Authorization': "Bearer #{token.token}" },
                                      params: { question: { title: nil,
                                                            body: nil ,
                                                            user_id: nil } },
                                      as: :json
          end

          it 'returns question errors' do
            expect(response.body).to be_json_eql("{\"title\":[\"can't be blank\"],
                                                \"body\":[\"can't be blank\"],
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
