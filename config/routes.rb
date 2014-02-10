require 'resque/server'

Enroll::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => "users/registrations" }

  mount Resque::Server, :at => '/resque'

  resources :courses, only: [:index, :show, :preview] do
    resources :reservations
    resources :students, only: [:index]

    member do
      post :preview
    end
  end
  get '/courses/new/:step', to: 'courses#new', as: :new_course_step
  get '/courses/:id/edit/:step', to: 'courses#edit', as: :edit_course_step

  # Teacher dashboard
  namespace :dashboard do
    resources :courses do
      member do
        get :share
        get :review
        get :publish
      end
      resources :students, only: [:index]
      resources :resources
      resource :payment_settings, only: [:edit, :update]
    end
    resources :landing_pages
  end

  # Student dashbaord
  namespace :student do
    resources :courses do
      resources :resources

      member do
        get :calendar
      end
    end
  end

  namespace :admin do
    resources :emails
  end
  get '/admin', to: 'admin/emails#index'

  resource :account, only: [:edit, :update] do
    # resources :courses
    get :restore
    post :restore
  end
  resources :avatars


  get '/go/:url', to: 'courses#show', as: :landing_page

  get '/about', to: 'welcome#about', as: :about_page

  root 'welcome#index'

  # Don't use www because of https cert being issued for enroll.io
  constraints subdomain: 'www' do
    get ':any', to: redirect(subdomain: nil, path: '/%{any}'), any: /.*/
  end
end
