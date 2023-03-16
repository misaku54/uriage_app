Rails.application.routes.draw do
  get 'sessions/new'
  root "static_pages#home"
  get  "/signup",  to: "users#new"
  resources :users
end
