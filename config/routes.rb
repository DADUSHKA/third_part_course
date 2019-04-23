Rails.application.routes.draw do
  get 'awards/index'
  root to: 'questions#index'
  devise_for :users

  concern :voteable do
    member do
      post :create_like
      post :create_dislike
      delete :delete_vote
    end
  end

  resources :attach_file, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index

  resources :questions, concerns: [:voteable] do
    resources :answers, shallow: true, only: %i[create update destroy] do
      member do
        post :assigning_as_best
      end
    end
  end
end
