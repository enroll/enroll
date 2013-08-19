require 'resque/server'

Enroll::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => "users/registrations" }

  mount Resque::Server, :at => '/resque'

  resources :courses do
    resources :reservations
    resources :students, only: [:index]
  end

  resource :account, only: [:edit, :update] do
    # resources :courses
  end

  get '/go/:url', to: 'courses#show', as: :landing_page

  root 'welcome#index'
end
