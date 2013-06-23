WorkshopPlatform::Application.routes.draw do
  resources :workshops
  resources :courses do
    resources :reservations
  end

  root 'welcome#index'
end
