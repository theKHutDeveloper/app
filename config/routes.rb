Rails.application.routes.draw do
  
  

  get 'admin_simple/index'

  get 'user/new'

  get 'user/create'

  get 'user/update'

  get 'user/edit'

  get 'user/destroy'

  get 'user/index'

  get 'user/show'

  get 'welcome/index'
  get 'locker/index'
  

  root 'welcome#index'
  
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users
  devise_for :lockers
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
end
