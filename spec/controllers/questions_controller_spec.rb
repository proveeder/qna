require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders a new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves new question to db' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save new question to db' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 're-renders "new" view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { question }

    context 'author update question' do
      before do
        # devise stuff
        allow(controller).to receive(:authenticate_user!).and_return(true)
        allow(controller).to receive(:current_user).and_return(question.user)
      end

      it 'Assigns requested question to @question' do
        patch :update, params: { id: question, question: { body: 'New body' } }, format: :js
        expect(assigns(:question)).to eq question
      end

      it 'Updates question body' do
        new_body = 'New body'
        patch :update, params: { id: question, question: { title: 'New title', body: new_body } }, format: :js
        question.reload
        expect(question.body).to eq new_body
      end
    end

    context 'Authenticated user but not author tries to delete question' do
      # re-sign-in
      sign_in_user

      it 'Assigns requested question to @question' do
        patch :update, params: { id: question, question: { body: 'New body' } }
        expect(assigns(:question)).to eq question
      end

      it 'do not change question' do
        old_body = question.body
        patch :update, params: { id: question, question: { body: 'New body' } }
        question.reload
        expect(question.body).to eq old_body
      end

      it 'receives 302 status code' do
        patch :update, params: { id: question, question: { body: 'New body' } }
        expect(response.response_code).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:found])
      end
    end

    context 'Not authenticated user tries to update question' do
      it 'receives 302 status code' do
        patch :update, params: { id: question, question: { body: 'New body' } }
        expect(response.response_code).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:found])
      end
    end
  end

  describe 'DELETE #destroy' do
    before { question }

    context 'author delete question' do
      # devise stuff
      before do
        allow(controller).to receive(:authenticate_user!).and_return(true)
        allow(controller).to receive(:current_user).and_return(question.user)
      end

      it 'deletes question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirect to "index" view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'anyone but author tries to delete question' do
      sign_in_user

      it 'do not delete question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'receives 302 status code' do
        delete :destroy, params: { id: question }
        expect(response.response_code).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:found])
      end
    end

    context 'Not authenticated user tries to delete question' do
      it 'receives 302 status code' do
        delete :destroy, params: { id: question }
        expect(response.response_code).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:found])
      end
    end
  end

  describe 'POST #set_best_answer' do
    let(:answer) { create(:answer) }

    context 'author set best answer' do
      before do
        # devise stuff
        allow(controller).to receive(:authenticate_user!).and_return(true)
        allow(controller).to receive(:current_user).and_return(answer.question.user)
      end

      it 'Assigns requested question to @question' do
        post :set_best_answer, params: { id: answer.question, best_answer_id: answer }, format: :js
        expect(assigns(:question)).to eq answer.question
      end

      it 'sets best answer' do
        post :set_best_answer, params: { id: answer.question, best_answer_id: answer }, format: :js
        question = answer.question
        question.reload
        expect(question.best_answer_id).to eq answer.id
      end
    end

    context 'Authenticated user but not author tries to set best answer' do
      sign_in_user

      it 'Assigns requested question to @question' do
        post :set_best_answer, params: { id: answer.question, best_answer_id: answer }
        expect(assigns(:question)).to eq answer.question
      end

      it 'receives 302 status code' do
        post :set_best_answer, params: { id: answer.question, best_answer_id: answer }
        expect(response.response_code).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:found])
      end
    end

    context 'Non-authenticated user tries to set best answer' do
      it 'receives 302 status code' do
        post :set_best_answer, params: { id: answer.question, best_answer_id: answer }
        expect(response.response_code).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:found])
      end
    end
  end

  describe 'POST #vote_for_question' do
    let(:question) { create(:question) }

    before do
      allow(controller).to receive(:authenticate_user!).and_return(true)
      allow(controller).to receive(:current_user).and_return(question.user)
    end

    context 'anyone changes answer rating' do
      sign_in_user

      it 'changes answer rating' do
        expect do
          post :vote_for_question, params: { id: question, liked: true }, format: :json
        end.to change(UserQuestionVote, :count).by(1)
      end

      it 'returns rating =1' do
        post :vote_for_question, params: { id: question, liked: true }, format: :json
        expect(JSON.parse(response.body)['rating']).to match(1)
      end
    end
  end
end
