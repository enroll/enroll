Enroll::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => "users/registrations" }

  resources :courses do
    resources :reservations
  end

  root 'welcome#index'
end
