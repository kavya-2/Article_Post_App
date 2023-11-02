Rails.application.routes.draw do
  root 'sessions#new'

  get '/sign_in', to: 'users#new' 
  post '/sign_in', to: 'users#create' 

  # get '/login', to: 'sessions#new' 
  # post '/login', to: 'sessions#create' 
  # get '/logout', to: 'sessions#destroy'
  
  get '/login', to: 'sessions#new', as: 'new_session'
  post '/login', to: 'sessions#create', as: 'sessions' 
  get '/logout', to: 'sessions#destroy', as: 'logout'

  resources :users
  # resources :articles, except: [:destroy] do 
  #   resources :comments, only: [:create, :edit, :update] 
  # end
  resources :articles do 
    resources :comments, only: [:create, :edit, :update] do
      get 'edit', on: :member 
      resources :replies, only: [:new, :create] 
    end
  end
end
