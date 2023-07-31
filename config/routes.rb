Rails.application.routes.draw do
  get    'sessions/new'
  root   'static_pages#home'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  namespace :admin do
    resources :users, expect: :new
    get    '/signup',  to: 'users#new'
  end
  resources :users, only: [:show]  do
    resources :makers, except: :show
    resources :producttypes, except: :show
    resources :sales
    get '/monthly_aggregate', to: 'aggregates#monthly_aggregate'
    get '/monthly_search', to: 'aggregates#monthly_search'
    get '/yearly_aggregate', to: 'aggregates#yearly_aggregate'
    get '/yearly_search', to: 'aggregates#yearly_search'
    get '/daily_aggregate', to: 'aggregates#daily_aggregate'
    get '/daily_search', to: 'aggregates#daily_search'
  end
end
