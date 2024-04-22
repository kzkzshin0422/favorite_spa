Rails.application.routes.draw do

  devise_for :users, controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
  sessions: "admin/sessions"
}

  scope module: :public do
    root to: "homes#top"
    get 'about' => 'homes#about' , as: 'about'
    get 'users' => 'users#index'
    get 'users/confirm'
    patch 'users/withdrawal'
    get 'users/:id' => 'users#show'
    resources :users, only: [:edit, :update]
    post '/search',  to: 'posts#search'
    get  '/search',  to: 'posts#search'
    resources :posts, only: [:new, :create, :index, :show, :edit, :update] do
      resources :comments, only: [:create]
    end
    
    delete 'posts/:id' => 'posts#destroy', as: 'destroy_post'
  end

  namespace :admin do
    resources :users, only: [:index, :show, :edit, :update]
    resources :posts, only: [:index, :show, :edit, :update]
    delete 'posts/:id' => 'posts#destroy', as: 'destroy_post'
  end

  devise_scope :user do
    post "guest_sign_in", to: "public/sessions#guest_sign_in"
  end

end


