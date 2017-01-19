Rails.application.routes.draw do
   
  get 'welcome/index'
  root 'welcome#index'
  get 'admin_simple/index'
  get 'message/index'

 
  
  get 'user/show'

  get 'locker/test'
  
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users
  
  resources :user
  resources :locker
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
end
