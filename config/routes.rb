Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

root 'ranking#year'


resources :rounds, :jassers, :users

get 'ranking/' => "ranking#year"
get 'ranking/year' => "ranking#year"
get 'ranking/month' => "ranking#month"
get 'ranking/versenker_und_roesis' => "ranking#versenker_und_roesis"
get 'ranking/last_12_months' => "ranking#last_12_months"
get 'ranking/last_3_months' => "ranking#last_3_months"
get 'ranking/ewig' => "ranking#ewig"
get 'ranking/day' => "ranking#day"


match 'login' => "users#login", via: [:get, :post], as: :login
match 'logout' => "users#logout", via: :get, as: :logout
match 'change_password' => "users#change_own_password", via: [:get, :patch], as: :change_password


end
