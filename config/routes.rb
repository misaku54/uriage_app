Rails.application.routes.draw do
  get 'sales/index'
  get 'sales/new'
  get 'sales/edit'
  get    'sessions/new'
  root   'static_pages#home'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users, only: [:show] 
  namespace :admin do
    resources :users
    get    '/signup',  to: 'users#new'
  end
  resources :users do
    resources :makers, except: :show
  end
  resources :users do
    resources :producttypes, except: :show
  end
end
