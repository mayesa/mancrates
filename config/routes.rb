Rails.application.routes.draw do
  devise_for :users

  authenticated do
    root to: 'orders#index'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :products

  resources :orders
end
