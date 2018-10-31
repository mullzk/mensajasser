Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

root 'ranking#year'


resources :rounds, :jassers, :users

get 'ranking/' => "ranking#year"
get 'ranking/:action', controller: "ranking"
get 'ranking/:action/:date', controller: "ranking"


match 'login' => "users#login", via: [:get, :post], as: :login
match 'logout' => "users#logout", via: :get, as: :logout
match 'change_password' => "users#change_own_password", via: [:get, :patch], as: :change_password


end
