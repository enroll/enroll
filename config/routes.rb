WorkshopPlatform::Application.routes.draw do
  resources :courses do
    resources :reservations
  end

  root 'welcome#index'
end
