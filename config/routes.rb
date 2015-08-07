Qbrick::Engine.routes.draw do
  devise_for :admins, class_name: 'Qbrick::Admin', module: :devise

  namespace :cms do
    resources :settings, only: %i(update_all index) do
      put :update_all, on: :collection
    end
    resources :pages, except: :show do
      post :sort, on: :collection
      get :mirror
    end

    resources :bricks, except: %i(edit index) do
      post :sort, on: :collection
    end

    resources :assets
    resources :ckimages, only: %i(create index destroy)

    resource :account, only: :edit do
      patch :update_password, on: :collection
    end

    resources :admins

    root to: 'pages#index'
  end

  scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/, defaults: { locale: -> { I18n.default_locale } } do
    namespace :api, defaults: { format: :json } do
      resources :pages, only: :index
    end

    resources :pages, only: %i(index), defaults: { locale: I18n.locale }
    get '(*url)' => 'pages#show', as: :page
  end

  get '/pages/:id' => 'pages#lookup_by_id'
  get '/sitemap' => 'sitemaps#index', format: 'xml'
end
