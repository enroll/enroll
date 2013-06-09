WorkshopPlatform::Application.routes.draw do
  resources :workshops

  root 'welcome#index'
end
