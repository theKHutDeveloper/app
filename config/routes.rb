Rails.application.routes.draw do
   
  get 'welcome/index'
  root 'welcome#index'
  get 'admin_simple/index'
  get 'user/show'
  get 'locker/remove_user'
  get 'message/new'
  
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users
  
  resources :user
  resources :locker
  resources :locker_assignment, only:[:create]
  resources :message
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
end
