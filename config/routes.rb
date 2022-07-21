Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :questions, only: %i[index new create show destroy] do
    resources :answers, only: %i[create]
  end
end
