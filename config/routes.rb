require 'resque/server'

Enroll::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => "users/registrations" }

  mount Resque::Server, :at => '/resque'

  resources :courses do
    resources :reservations
    resources :students, only: [:index]
  end

  root 'welcome#index'
end
