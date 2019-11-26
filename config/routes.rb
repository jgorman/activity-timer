Rails.application.routes.draw do
  root 'welcome#index'

  devise_for :users

  get '/timer', to: 'timer#show'
  post '/timer', to: 'timer#update'
  patch '/timer', to: 'timer#update'

  namespace :admin do
    resources :users
  end

  resources :clients do
    resources :projects, only: %i[new]
  end

  resources :projects do
    resources :activities, only: %i[new]
  end

  resources :activities
end
