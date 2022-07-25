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

  describe 'DELETE #destroy' do
    let(:answer) { create(:answer) }

    before do
      allow(controller).to receive(:authenticate_user!).and_return(true)
      allow(controller).to receive(:current_user).and_return(answer.user)
    end

    context 'author delete answer' do
      it 'deletes answer' do
        expect do
          delete :destroy, params: { question_id: answer.question, id: answer }
        end.to change(Answer, :count).by(-1)
      end

      it 'redirect to "show" question view' do
        delete :destroy, params: { question_id: answer.question, id: answer }
        expect(response).to redirect_to answer.question
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

      it 'receives 403 status code' do
        delete :destroy, params: { question_id: answer.question, id: answer }
        expect(response.response_code).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:forbidden])
      end
    end
  end
end
