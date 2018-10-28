Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

root 'welcome#index'


resources :rounds, :jassers, :users

get 'ranking/' => "ranking#year"
get 'ranking/:action', controller: "ranking"
get 'ranking/:action/:date', controller: "ranking"

end
