WorkshopPlatform::Application.routes.draw do
  root 'welcome#index'

  resources :workshops
end
