Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :attach_file, only: :destroy

  resources :questions do
    resources :answers, shallow: true, only: %i[create update destroy] do
      member do
        post :assigning_as_best
      end
    end
  end
end
