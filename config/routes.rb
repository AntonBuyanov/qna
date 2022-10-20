Rails.application.routes.draw do
  get 'links/destroy'
  devise_for :users
  resources :questions do
    resources :answers, shallow: true do
      patch :set_best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy

  root to: 'questions#index'
end
