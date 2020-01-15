Rails.application.routes.draw do
  root 'home#index'

  get '/alert', to: 'home#alert'
  get '/console', to: 'home#console'
  get '/env', to: 'home#env'

  devise_for :users, controllers: { registrations: 'users/registrations' }

  # TODO Convert these to a nice syntax.
  get '/timer', to: 'timer#index'
  post '/timer', to: 'timer#create'
  delete '/timer', to: 'timer#destroy'
  post '/timer/finish', to: 'timer#finish'
  post '/timer/name', to: 'timer#name'
  post '/timer/project', to: 'timer#project'
  post '/timer/load_more', to: 'timer#load_more'
  get '/timer/replace_page', to: 'timer#replace_page'
  get '/timer/replace_clock', to: 'timer#replace_clock'
  patch '/timer/activity/:id', to: 'timer#activity', as: 'timer_activity'

  resources :home, only: [] do
    collection do
      post :guest
    end
  end

  namespace :admin do
    resources :users do
      member do
        post :become
      end
    end
  end

  resources :clients do
    resources :projects, only: %i[new create]
  end

  resources :projects, except: %i[new create] do
    resources :activities, only: %i[new create]
  end

  resources :activities, except: %i[new create]
end
