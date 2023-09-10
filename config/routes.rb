Rails.application.routes.draw do
  #get 'book_comments/create'
  #get 'book_comments/destroy'
  #get 'favorites/create'
  #get 'favorites/destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root :to =>"homes#top"
  get "home/about"=>"homes#about"
  devise_for :users
  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only:[:create, :destroy]
    get "follower" => "relationships#show_follower" ,as: "follower"
    get "followed" => "relationships#show_followed" ,as: "followed"
  end
  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resources :book_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end
  get "search" => "searches#search"
  resources :groups, only: [:new, :index, :show, :create, :edit, :update] do
    resource :group_users, only: [:create, :destroy]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
