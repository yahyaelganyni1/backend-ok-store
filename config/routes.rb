Rails.application.routes.draw do
  resources :products
  devise_for :users,
             controllers: {
                 sessions: 'users/sessions',
                 registrations: 'users/registrations'
             }
  get '/member-data', to: 'members#show'


  get '/all-users', to: 'members#all_users'

  get '/update-user-to-seller/:id', to: 'members#update_user_to_seller'

  get '/update-seller-to-user/:id', to: 'members#update_seller_to_user'

end