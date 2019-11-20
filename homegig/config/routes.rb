Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}
  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
  end
  devise_scope :user do
    get 'signup', to: 'devise/registrations#new'
    get 'profile_management', to: 'profiles#profile_management'
    get 'manage', to: 'gigs#manage'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'static_pages#home'
  resources :gigs

  get 'about', to: 'static_pages#about'
  get 'faq', to: 'static_pages#faq'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'terms_of_use', to: 'static_pages#terms_of_use'
  get 'contact', to: 'static_pages#contact'

  get 'offerings', to: 'offerings#index', as: 'offeringAll'
  get '/offerings/:id', to: 'offerings#show', as: 'offering'
  get '/offerings?category=:id', to: 'offerings#index', as: 'offeringCat'

  devise_scope :post do
    get '/offerings/:id/new', to: 'reviews#new', as: 'newReview'
    post '/offerings/:id/create', to: 'reviews#create', as: 'createReview'
  end

  post '/offerings/:id/notify_interest', to: 'notifications#notify_interest', as: 'notify_interest'

  get "stripe/connect", to: 'stripe#connect', as: :stripe_connect
  get 'stripe/register', to: 'stripe#register'
  get 'stripe/public_key', to: 'stripe#public_key'
  get 'stripe/create_checkout_session', to: 'stripe#create_checkout_session'
  get 'pay', to: 'stripe#pay'  

end
