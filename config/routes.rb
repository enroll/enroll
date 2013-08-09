Enroll::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => "users/registrations" }

  resources :courses do
    resources :reservations
  end

  get '/go/:url', to: 'courses#show', as: :landing_page

  root 'welcome#index'
end
