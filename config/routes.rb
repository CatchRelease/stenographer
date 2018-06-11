# frozen_string_literal: true

Stenographer::Engine.routes.draw do
  resources :changes, only: %i[index show], constraints: Stenographer::RoutingConstraints::ViewerOnly.new
  resources :changes, only: %i[create] # Created separately because we don't want it behind the routing constraints

  scope '/admin' do
    get '/' => 'admin#index', as: :admin_index, constraints: Stenographer::RoutingConstraints::ManagerOnly.new
  end

  namespace :admin do
    resources :authentications, only: %i[index show destroy], constraints: Stenographer::RoutingConstraints::ManagerOnly.new
    resources :changes, constraints: Stenographer::RoutingConstraints::ManagerOnly.new
    resources :outputs, constraints: Stenographer::RoutingConstraints::ManagerOnly.new
  end

  get '/auth/:provider', to: 'authentications#create', as: :authentication # Used so we can access authentication_path('provider')
  get '/auth/:provider/callback', to: 'authentications#create'
  get '/auth/failure', to: 'authentications#failure'

  root 'changes#index', constraints: Stenographer::RoutingConstraints::ViewerOnly.new
end
