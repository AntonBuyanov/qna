Rails.application.routes.draw do
  get 'links/destroy'
  devise_for :users

  concern :voted do
    member do
      patch :like
      patch :dislike
      delete :cancel
    end
  end

  resources :questions, concerns: :voted  do
    resources :answers, concerns: :voted, shallow: true do
      patch :set_best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :badges, only: :index

  root to: 'questions#index'
end
