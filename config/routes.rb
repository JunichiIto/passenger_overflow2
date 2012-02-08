PassengerOverflow2::Application.routes.draw do
  resources :users, only: [:index, :show, :new, :create]
  resources :sessions, only: [:create]
  resources :questions, only: [:new, :create, :show, :index] do
    resources :answers, only: [:create] do
      post :accept, on: :member
      post :vote, on: :member
    end
  end  
  #resources :answers do
  #  post :accept, on: :member
  #  post :vote, on: :member
  #end

  match "/signup", to: "users#new"
  match "/signin",  to: "sessions#new"
  match "/signout", to: "sessions#destroy"

  root to: "questions#index"
end
