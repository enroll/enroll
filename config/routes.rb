Enroll::Application.routes.draw do
  devise_for :instructors

  resources :courses do
    resources :reservations
  end

  root 'welcome#index'
end
