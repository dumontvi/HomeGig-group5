Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}
  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
    get 'change_password', to: 'devise/passwords#edit'
  end
  
  devise_scope :user do
    get 'signup', to: 'devise/registrations#new'
    get 'profile_management', to: 'profiles#profile_management'
    put 'update_user_profile', to: 'profiles#update_user'
    get 'manage', to: 'offerings#manage'
  end

  root to: 'static_pages#home'
  resources :gigs

  get 'about', to: 'static_pages#about'
  get 'faq', to: 'static_pages#faq'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'terms_of_use', to: 'static_pages#terms_of_use'
  get 'contact', to: 'static_pages#contact'

  get 'offerings', to: 'offerings#index', as: 'offeringAll'
  get '/offerings/posts/:id', to: 'offerings#show', as: 'offering'
  get '/offerings?categoryId=:categoryId', to: 'offerings#index', as: 'offeringCat'
  get '/offerings/new', to: 'offerings#new', as: 'newOfferingGig'
  get 'offerings/:id/edit', to: 'offerings#edit', as: 'edit_offering'
  post '/offerings/create', to: 'offerings#create', as: 'createOfferingGig'
  put 'offerings/:id/update', to: 'offerings#update', as: 'update_offering'
  delete 'offerings/:id/delete', to: 'offerings#delete', as: 'delete_offering'
  post '/offerings/:id/notify_interest', to: 'notifications#notify_offering_interest', as: 'notify_offering_interest'
  devise_scope :post do
    get '/offerings/posts/:id/new', to: 'reviews#new', as: 'newReview'
    post '/offerings/posts/:id/create', to: 'reviews#create', as: 'createReview'
  end

  get 'seekings', to: 'seekings#index', as: 'seekingAll'
  get '/seekings?categoryId=:categoryId', to: 'seekings#index', as: 'seekingCat'
  get '/seeking/posts/:id', to: 'seekings#show', as: 'seeking'
  get '/seekings/new', to: 'seekings#new', as: 'newSeekingGig'
  get 'seekings/:id/edit', to: 'seekings#edit', as: 'edit_seeking'
  post '/seekings/create', to: 'seekings#create', as: 'createSeekingGig'
  put 'seekings/:id/update', to: 'seekings#update', as: 'update_seeking'
  delete 'seekings/:id/delete', to: 'seekings#delete', as: 'delete_seeking'
  post '/seekings/:id/notify_interest', to: 'notifications#notify_seeking_interest', as: 'notify_seeking_interest'

  get 'notifications', to: 'notifications#notifications'
  post 'notifications/acknowledge_all', to: 'notifications#acknowledge_all'
  post 'notifications/:id/approve', to: 'notifications#approve', as: 'approve'

  get "stripe/connect", to: 'stripe#connect', as: :stripe_connect
  get 'stripe/register', to: 'stripe#register'
  get 'stripe/public_key', to: 'stripe#public_key'
  get 'stripe/checkout_session/:notificationId', to: 'stripe#checkout_session'
  get 'stripe/success', to: 'stripe#success'  
  get 'stripe/error', to: 'stripe#error' 

end
