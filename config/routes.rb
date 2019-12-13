Rails.application.routes.draw do
  root 'welcome#index'

  devise_for :users

  get '/timer', to: 'timer#index'
  post '/timer', to: 'timer#create'
  delete '/timer', to: 'timer#destroy'
  post '/timer/finish', to: 'timer#finish', as: 'timer_finish'
  post '/timer/name', to: 'timer#name', as: 'timer_name'
  post '/timer/project', to: 'timer#project', as: 'timer_project'
  get '/timer/replace_page', to: 'timer#replace_page', as: 'timer_replace_page'
  get '/timer/replace_clock', to: 'timer#replace_clock', as: 'timer_replace_clock'
  patch '/timer/activity/:id', to: 'timer#activity', as: 'timer_activity'

  namespace :admin do
    resources :users
  end

  resources :clients do
    resources :projects, only: %i[new create]
  end

  resources :projects, except: %i[new create] do
    resources :activities, only: %i[new create]
  end

  resources :activities, except: %i[new create]
end
