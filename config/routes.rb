Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  devise_for :users
  resources :customers, only: %i[index show create update destroy]
  resources :messages, only: %i[index create]
  resources :message_templates, only: %i[index show create update destroy]
end
