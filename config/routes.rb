Rails.application.routes.draw do
  use_doorkeeper
  devise_for :user, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  root to: 'questions#index'

  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
      end
      resource :questions do
        get :index, on: :collection
      end
    end
  end

  resources :questions, except: %i[edit] do
    post :vote_for_question, on: :member
    post :set_best_answer, on: :member

    resources :answers, only: %i[create destroy update] do
      post :vote_for_answer, on: :member
    end
  end

  resources :attachments, only: %i[destroy]
  resources :comments, only: %i[create]

  get '/change_email', to: 'user_activations#change_email'
  post '/update_email', to: 'user_activations#update_email'

  mount ActionCable.server => '/cable'
end
