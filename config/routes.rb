Enroll::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => "users/registrations" }

  resources :courses do
    resources :reservations
  end

  constraints(Subdomain) do
    get '/', to: 'courses#show'
  end

  root 'welcome#index'
end
