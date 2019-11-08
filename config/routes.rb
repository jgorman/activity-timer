Rails.application.routes.draw do
  resources :activities
  resources :projects
  resources :clients
  get 'welcome/index'
  root 'welcome#index'

  devise_for :users
end
