Rails.application.routes.draw do
  namespace :admin do
    get 'users/new'
    get 'users/edit'
    get 'users/show'
    get 'users/index'
  end
  get    'sessions/new'
  root   'static_pages#home'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users
  namespace :admin do
    resources :users
  end
end
