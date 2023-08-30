class CsvExportConstraint
  # リクエストのパラメータにexport_csvがあればtrueを返す
  def self.matches?(request)
    request.params.has_key?(:export_csv)
  end
end

Rails.application.routes.draw do
  root   'static_pages#home'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
  namespace :admin do
    resources :users, expect: :new
    get    '/signup',  to: 'users#new'
  end

  resources :users, only: [:show]  do
    resources :makers, except: :show do
      collection do
        get :search, action: :export_csv, constraints: CsvExportConstraint
        get :search
      end
    end

    resources :producttypes, except: :show do
      collection do
        get :search, action: :export_csv, constraints: CsvExportConstraint
        get :search
      end
    end

    resources :sales do
      collection do
        get :search, action: :export_csv, constraints: CsvExportConstraint
        get :search
      end
    end

    resources :events, except: :index

    get '/monthly_aggregate', to: 'aggregates#monthly_aggregate'
    get '/monthly_search', to: 'aggregates#monthly_search'
    get '/yearly_aggregate', to: 'aggregates#yearly_aggregate'
    get '/yearly_search', to: 'aggregates#yearly_search'
    get '/daily_aggregate', to: 'aggregates#daily_aggregate'
    get '/daily_search', to: 'aggregates#daily_search'
  end
end
