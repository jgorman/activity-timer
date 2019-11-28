Rails.application.routes.draw do
  root 'welcome#index'

  devise_for :users

  get '/timer', to: 'timer#index'
  post '/timer', to: 'timer#create'
  patch '/timer', to: 'timer#update'
  delete '/timer', to: 'timer#destroy'

  post '/timer/finish', to: 'timer#finish', as: 'timer_finish'

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
