Rails.application.routes.draw do
  resources :categories
  resources :reviews
  resources :products
  devise_for :users,
             controllers: {
                 sessions: 'users/sessions',
                 registrations: 'users/registrations'
             }

resource :cart, only: [:show] 

# show cart             
  post 'add_to_cart_by_number/:id', to: 'cart_items#add_to_cart_by_number', as: 'add_to_cart_by_number'

  get 'all_cart_items', to: 'cart_items#all_cart_items', as: 'all_cart_items'

  get 'cart_products_index', to: 'cart_items#cart_products_index'

  delete 'destroy_cart_item/:id', to: 'cart_items#destroy_cart_item', as: 'destroy_cart_item'

  put 'increase_quantity/:id', to: 'cart_items#increase_quantity', as: 'increase_quantity'

  put 'decrease_quantity/:id', to: 'cart_items#decrease_quantity', as: 'decrease_quantity'

# user
  get '/member-data', to: 'members#show'

  get '/all-users', to: 'members#all_users'

  get '/update-user-to-seller/:id', to: 'members#update_user_to_seller'

  get '/update-seller-to-user/:id', to: 'members#update_seller_to_user'

# reviews

   get 'product_reviews/:product_id', to: 'reviews#product_reviews', as: 'product_reviews'          
    
  

end