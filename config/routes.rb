Rails.application.routes.draw do

  authenticated :user do
   root to: 'fields#index', as: :authenticated_root
  end

  root to: 'application#index'

  devise_for :users

  post  '/fields',          to: 'fields#create'
  post  '/new_point',       to: 'fields#new_point'
  get   '/fields/:id',      to: 'fields#show'
  get   '/accept_field/:id',to: 'fields#receive_request'

  mount ActionCable.server, at: '/cable'

end
