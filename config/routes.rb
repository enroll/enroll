Enroll::Application.routes.draw do
  devise_for :instructors, :controllers => { :registrations => "instructors/registrations" }

  resources :courses do
    resources :reservations
  end

  root 'welcome#index'
end
