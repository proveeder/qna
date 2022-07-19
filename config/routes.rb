Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :questions, only: %i[index create] do
    resources :answers, only: %i[create]
  end
end
