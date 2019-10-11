Rails.application.routes.draw do
  get 'graph/year'
  get 'graph/year/:date', controller: "graph", action: "year"
  get 'graph/running/:id', controller: "graph", action: "running"
  get 'graph/ewig/:id', controller: "graph", action: "ewig"
  get 'graph/overall', controller: "graph", action: "overall"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

root 'ranking#year'


resources :rounds, :jassers, :users

get 'ranking/' => "ranking#year"
get 'ranking/year' => "ranking#year"
get 'ranking/year/:date', controller: "ranking", action: "year"
get 'ranking/month' => "ranking#month"
get 'ranking/month/:date', controller: "ranking", action: "month"
get 'ranking/versenker_und_roesis' => "ranking#versenker_und_roesis"
get 'ranking/versenker_und_roesis/:date', controller: "ranking", action: "versenker_und_roesis"
get 'ranking/last_12_months' => "ranking#last_12_months"
get 'ranking/last_12_months/:date', controller: "ranking", action: "last_12_months"
get 'ranking/last_3_months' => "ranking#last_3_months"
get 'ranking/last_3_months/:date', controller: "ranking", action: "last_3_months"
get 'ranking/ewig' => "ranking#ewig"
get 'ranking/day' => "ranking#day"
get 'ranking/day/:date', controller: "ranking", action: "day"
get 'ranking/berseker' => "ranking#berseker"
get 'ranking/berseker/:date', controller: "ranking", action: "berseker"
get 'ranking/schaedling' => "ranking#schaedling"
get 'ranking/schaedling/:date', controller: "ranking", action: "schaedling"
get 'ranking/angstgegner/:id', controller: "ranking", action: "angstgegner"


match 'login' => "users#login", via: [:get, :post], as: :login
match 'logout' => "users#logout", via: :get, as: :logout
match 'change_password' => "users#change_own_password", via: [:get, :patch], as: :change_password


end
