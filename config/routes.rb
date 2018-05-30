# frozen_string_literal: true

Stenographer::Engine.routes.draw do
  resources :changes, only: %i[index show], constraints: Stenographer::RoutingConstraints::ViewerOnly.new
  resources :changes, only: %i[create] # Created separately because we don't want it behind the routing constraints

  resources :admins, constraints: Stenographer::RoutingConstraints::ManagerOnly.new

  root 'changes#index'
end
