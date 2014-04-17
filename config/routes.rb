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
        post :destroy_logo
        post :destroy_instructor_photo
      end
      resources :students, only: [:index]
      resources :resources
      resource :payment_settings, only: [:edit, :update]
    end
    resources :landing_pages
    resources :cover_images
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
    resources :posts
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

  get '/blog', to: 'blog_posts#index', as: :blog_posts
  get '/blog/:id', to: 'blog_posts#show', as: :blog_post

  root 'welcome#index'
end
