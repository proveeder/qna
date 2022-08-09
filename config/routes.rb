Rails.application.routes.draw do
  devise_for :user, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  # get '/auth/twitter2/callback', to: 'omniauth_callbacks#twitter2'
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

  mount ActionCable.server => '/cable'
end
