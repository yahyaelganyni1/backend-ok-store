Rails.application.routes.draw do
  resources :products
  devise_for :users,
             controllers: {
                 sessions: 'users/sessions',
                 registrations: 'users/registrations'
             }
  get '/member-data', to: 'members#show'

  get '/all-users', to: 'members#all_users'

  # patch '/update-user-to-seller/:id', to: 'members#update_user_to_seller'

  get '/update-user-to-seller/:id', to: 'members#update_user_to_seller'


end