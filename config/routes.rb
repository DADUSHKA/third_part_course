Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :questions do
    member do
      delete :delete_attach_file
    end
    resources :answers, shallow: true, only: %i[create update destroy] do
      member do
        post :assigning_as_best
      end
    end
  end
end
