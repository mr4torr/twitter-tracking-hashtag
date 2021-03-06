Rails.application.routes.draw do
    devise_for :users

    root to: "home#index"


    get 'popup_signin' => 'popup#signin', as: :popup_signin
    get 'popup_signup' => 'popup#signup', as: :popup_signup
    get 'popup_forgot' => 'popup#forgot', as: :popup_forgot


    namespace :painel do
        get 'dashboard' => 'dashboard#index', as: :dashboard
        resources :tags, only: %i[new create destroy]
        get '/tags/import/:id/:name' => 'tags#import_tweets', as: :tag_import

    end
end
