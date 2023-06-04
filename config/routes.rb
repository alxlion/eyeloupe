Eyeloupe::Engine.routes.draw do

  root to: "application#root"

  resources :in_requests, only: [:index, :show]
  resources :out_requests, only: [:index, :show]
  resources :exceptions, only: [:index, :show]

  resource :data, only: [:destroy]

  resource :configs, only: [:update]

end
