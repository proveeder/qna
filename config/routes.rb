Rails.application.routes.draw do
  devise_for :user, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  root to: 'questions#index'

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
