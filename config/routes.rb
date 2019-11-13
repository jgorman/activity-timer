Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'

  devise_for :users

  namespace :admin do
    resources :users
  end

  resources :clients
  resources :projects
  resources :activities
end
