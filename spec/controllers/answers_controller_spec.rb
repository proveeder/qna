require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST answers#create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves new answer to db' do
        expect do
          answer_attrs = attributes_for(:answer)
          post :create, params: { question_id: answer_attrs[:question], answer: answer_attrs },
                        format: :js
        end.to change(Answer, :count).by(1)
      end
    end

    let(:answer_attrs) { attributes_for(:invalid_answer) }

    context 'with invalid attributes' do
      it 'does not save new answer to db' do
        expect do
          post :create, params: { question_id: answer_attrs[:question], answer: answer_attrs }, format: :js
        end.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH answers#update' do
    let(:answer) { create(:answer) }

    before do
      allow(controller).to receive(:authenticate_user!).and_return(true)
      allow(controller).to receive(:current_user).and_return(answer.user)
    end

    context 'author edit answer with valid data' do
      it 'assigns answer to @answer' do
        patch :update, params: { question_id: answer.question, id: answer, answer: { body: 'New body' } },
                       format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'updates body' do
        new_body = 'New body'
        patch :update, params: { question_id: answer.question, id: answer, answer: { body: new_body } },
                       format: :js
        answer.reload
        expect(answer.body).to eq new_body
      end
    end

    context 'author edit answer with invalid data' do
      it 'assigns answer to @answer' do
        patch :update, params: { question_id: answer.question, id: answer, answer: { body: 'New body' } },
                       format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'does not update body' do
        old_body = answer.body
        patch :update, params: { question_id: answer.question, id: answer, answer: { body: '' } },
                       format: :js
        answer.reload
        expect(answer.body).to eq old_body
      end
    end

    context 'anybody but author tries to edit answer' do
      sign_in_user

      it 'assigns answer to @answer' do
        patch :update, params: { question_id: answer.question, id: answer, answer: { body: 'New body' } }
        expect(assigns(:answer)).to eq answer
      end

      it 'does not update body' do
        old_body = answer.body
        patch :update, params: { question_id: answer.question, id: answer, answer: { body: 'New body' } }
        answer.reload
        expect(answer.body).to eq old_body
      end

      it 'receives 302 status code' do
        patch :update, params: { question_id: answer.question, id: answer, answer: { body: 'New body' } }
        expect(response.response_code).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:found])
      end
    end

    context 'Not authenticated user tries to update question'
  end

  describe 'DELETE #destroy' do
    let(:answer) { create(:answer) }

    before do
      allow(controller).to receive(:authenticate_user!).and_return(true)
      allow(controller).to receive(:current_user).and_return(answer.user)
    end

    context 'author delete answer' do
      it 'deletes answer' do
        expect do
          delete :destroy, params: { question_id: answer.question, id: answer }, format: :js
        end.to change(Answer, :count).by(-1)
      end
    end

    context 'anyone but author tries to delete answer' do
      # re-sign-in to other user
      sign_in_user

      it 'do not delete answer' do
        expect do
          delete :destroy, params: { question_id: answer.question, id: answer }
        end.to_not change(Answer, :count)
      end

      it 'receives 302 status code' do
        delete :destroy, params: { question_id: answer.question, id: answer }
        expect(response.response_code).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:found])
      end
    end
  end

  describe 'POST #vote_for_answer' do
    let(:answer) { create(:answer) }

    before do
      allow(controller).to receive(:authenticate_user!).and_return(true)
      allow(controller).to receive(:current_user).and_return(answer.user)
    end

    context 'author of answer tries to change answer rating' do
      it 'receives 302 status code' do
        post :vote_for_answer, params: { question_id: answer.question, id: answer, liked: true }, format: :json
        expect(response.response_code).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:found])
      end
    end

    context 'anyone but author of answer changes answer rating' do
      sign_in_user

      it 'changes answer rating' do
        expect do
          post :vote_for_answer, params: { question_id: answer.question, id: answer, liked: true }, format: :json
        end.to change(UserAnswerVote, :count).by(1)
      end

      it 'returns rating =1' do
        post :vote_for_answer, params: { question_id: answer.question, id: answer, liked: true }, format: :json
        expect(JSON.parse(response.body)['rating']).to match(1)
      end
    end
  end
end
