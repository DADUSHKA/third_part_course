Rails.application.routes.draw do
  get 'awards/index'
  root to: 'questions#index'
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks'}

  concern :voteable do
    member do
      post :create_like
      post :create_dislike
      delete :delete_vote
    end
  end

  concern :commentable do
    resources :comments, only: :create
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index

  resources :questions, concerns: [:voteable, :commentable] do
    resources :answers, shallow: true, only: %i[create update destroy], concerns: [:voteable, :commentable] do
      member do
        post :assigning_as_best
      end
    end
  end
end
