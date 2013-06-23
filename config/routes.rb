WorkshopPlatform::Application.routes.draw do
  resources :workshops
  resources :courses

  root 'welcome#index'
end
