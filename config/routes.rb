Rails.application.routes.draw do
  get    'sessions/new'
  root   'static_pages#home'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users, only: [:index, :show] 
  namespace :admin do
    resources :users
    get    '/signup',  to: 'users#new'
  end
  resources :users do
    member do
      resources :makers
    end
  end
end
