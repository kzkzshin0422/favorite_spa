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
    get 'users/:id' => 'users#show', as: 'user'
    resources :users, only: [:edit, :update] do
      resource :relationships, only: [:create, :destroy]
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
    end
    post '/search',  to: 'posts#search'
    get  '/search',  to: 'posts#search'
    get 'posts/draft/index' => 'posts#draft_index', as: 'draft_posts'
    resources :posts, only: [:new, :create, :index, :show, :edit, :update] do
      resources :comments, only: [:create]
    end
    delete 'posts/:id' => 'posts#destroy', as: 'destroy_post'
  end

  namespace :admin do
    get 'users/:id' => 'users#show' , as: 'user'
    resources :users, only: [:index, :edit, :update] do
      get 'confirm' => 'users#confirm' , as: 'confirm'
      patch 'users/withdrawal' => 'users#withdrawal' ,as: 'withdrawal'
    end
    resources :posts, only: [:index, :show, :edit, :update] do
      delete 'comments/:id' => 'comments#destroy' , as: 'destroy_comment'
    end
    delete 'posts/:id' => 'posts#destroy', as: 'destroy_post'
  end

  devise_scope :user do
    post "guest_sign_in", to: "public/sessions#guest_sign_in"
  end

end


