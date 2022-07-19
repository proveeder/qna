Rails.application.routes.draw do
  resources :questions, only: %i[create] do
    resources :answers, only: %i[create]
  end
end
