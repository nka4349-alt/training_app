Rails.application.routes.draw do
  root "home#show"
  get "/workout", to: "workouts#show"
  get "/schedule", to: "schedule#show"
  get "/settings", to: "profiles#edit"

  resources :users, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]

  resource :profile, only: [:edit, :update]

  resources :workout_sessions, only: [:show, :create] do
    member { patch :finish }

    get "exercises/picker", to: "exercises#picker"
    get "exercises/:body_part", to: "exercises#index", as: :exercises_by_body_part

    resources :workout_exercises, only: [:create, :destroy] do
      post :add_set, on: :member
      post :restore_plan, on: :member
      patch :apply_first_weight, on: :member
    end

    resources :pain_logs, only: [:create, :update, :destroy]
  end

  resources :set_entries, only: [:update]

  get "/progress", to: "progress#show"
  get "/meal_ideas", to: "meal_ideas#show"
  get "/privacy", to: "public_pages#privacy"
  get "/delete-account", to: "public_pages#delete_account"
end
