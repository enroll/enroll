require 'resque/server'

Enroll::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => "users/registrations" }

  mount Resque::Server, :at => '/resque'

  resources :courses do
    resources :reservations
    resources :students, only: [:index]

    member do
      post :preview
    end
  end
  get '/courses/new/:step', to: 'courses#new', as: :new_course_step
  get '/courses/:id/edit/:step', to: 'courses#edit', as: :edit_course_step

  namespace :dashboard do
    resources :courses do
      member do
        get :share
        get :review
        get :publish
      end
      resources :students, only: [:index]
    end
    resources :landing_pages
  end

  resource :account, only: [:edit, :update] do
    # resources :courses
  end

  resource :payment_settings, only: [:edit, :update]

  get '/go/:url', to: 'courses#show', as: :landing_page

  get '/boom', to: 'welcome#boom'

  root 'welcome#index'
end
