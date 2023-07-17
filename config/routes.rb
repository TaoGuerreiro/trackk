# frozen_string_literal: true

Rails.application.routes.draw do
  require 'sidekiq/web'
  devise_for :users
  root to: 'servers#index'

  post '/google_drive/webhook', to: 'webhooks#receive'

  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :servers, exept: %i[index]
end
