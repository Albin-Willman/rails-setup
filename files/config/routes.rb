Rails.application.routes.draw do
  resource :user
  resources :user_sessions, only: [:create]
  get 'login', to: 'user_sessions#new', as: 'login'
  get 'logout', to: 'user_sessions#destroy', as: 'logout'

  root to: 'home#start'
end
