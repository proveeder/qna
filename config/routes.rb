Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions, except: %i[edit] do
    post :set_best_answer, on: :member

    resources :answers, only: %i[create destroy update]
  end

  resources :attachments, only: %i[destroy]
end
