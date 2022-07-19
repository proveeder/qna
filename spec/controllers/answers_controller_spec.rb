require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST answers#create' do
    context 'with valid attributes' do
      it 'saves new answer to db' do
        expect { post :create, params: { question_id: create(:question).id, answer: attributes_for(:answer) } }.to change(Answer, :count).by(1)
      end

      # TODO: uncomment for redirect
      # it 'redirect to show view' do
      #   post :create, params: { question: attributes_for(:answer) }
      #   expect(response).to redirect_to question_path(assigns(:answer))
      # end
    end

    context 'with invalid attributes' do
      it 'does not save new answer to db' do
        expect { post :create, params: { question_id: create(:question).id, answer: attributes_for(:invalid_answer) } }.to_not change(Answer, :count)
      end

      # TODO: uncomment for check view
      # it 're-renders "new" view' do
      #   post :create, params: { question: attributes_for(:invalid_answer) }
      #   expect(response).to render_template :new
      # end
    end
  end

end
