# frozen_string_literal: true

Stenographer::Engine.routes.draw do
  resources :changes, only: %i[index show], constraints: Stenographer::RoutingConstraints::ViewerOnly.new
  resources :admins, constraints: Stenographer::RoutingConstraints::ManagerOnly.new

  root 'changes#index'
end
