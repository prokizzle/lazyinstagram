  require 'sidekiq/web'
  require "sidekiq/throttled/web"
  require 'sidekiq/cron/web'

Rails.application.routes.draw do
  resources :whitelists
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  Sidekiq::Throttled::Web.enhance_queues_tab!
  mount Sidekiq::Web => '/sidekiq'

  get '/queues' => 'queues#index'
  root to: "discovery#index"

  resources :follows, only: [:index]

  get '/discovery-settings' => 'discovery#index'
  post '/discovery-settings' => 'discovery#create'
end
