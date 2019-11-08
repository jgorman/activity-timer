Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'

  devise_for :users

  namespace :admin do
    resources :users
  end

  resources :activities
  resources :projects
  resources :clients
end
