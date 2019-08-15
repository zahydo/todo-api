Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :todos, defaults: { format: 'json' } do
    resources :items, defaults: { format: 'json' }
  end
end
