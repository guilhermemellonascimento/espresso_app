Rails.application.routes.draw do
  root "dashboard#index"

  devise_for :users, controllers: {
    registrations: "user/registrations",
    sessions: "user/sessions"
  }

  resources :dashboard

  namespace :settings do
    resource :mfa, controller: :mfa, except: [:show, :edit] do
      collection do
        get :index
      end
    end
  end
end
