AwesomeParty::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do
    get 'sign_in', :to => 'devise/sessions#new', :as => :new_session
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  resources :attendants do
    match "by_event/:event_permalink", on: :collection, action: "by_event", as: "by_event", via: [:get, :post]
  end

  root to: "home#index"
end
