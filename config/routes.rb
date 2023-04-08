Rails.application.routes.draw do
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
    resources :producttypes, except: :show
    resources :sales, except: :show
    get '/aggregate', to: 'sales#aggregate_result'
  end

end
