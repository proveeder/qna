require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST answers#create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves new answer to db' do
        expect do
          post :create, params: { question_id: create(:question), answer: attributes_for(:answer) }
        end.to change(Answer, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save new answer to db' do
        expect do
          post :create, params: { question_id: create(:question), answer: attributes_for(:invalid_answer) }
        end.to_not change(Answer, :count)
      end
    end

    it 'redirect to question' do
      question = create(:question)
      post :create, params: { question_id: question, answer: attributes_for(:answer) }
      expect(response).to redirect_to question_path(question)
    end
  end

end
