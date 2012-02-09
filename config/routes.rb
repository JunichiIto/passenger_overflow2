PassengerOverflow2::Application.routes.draw do
  resources :users, only: [:index, :show, :new, :create]
  resources :sessions, only: [:create, :new, :destroy]
  resources :questions, only: [:new, :create, :show, :index] do
    resources :answers, only: [:create] do
      post :accept, on: :member
      post :vote, on: :member
    end
  end  

  root to: "questions#index"
end
