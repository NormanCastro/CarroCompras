Rails.application.routes.draw do


  mount ForestLiana::Engine => '/forest'
  	devise_for :users, :controllers => {
  		:omniauth_callbacks => 'users/omniauth_callbacks'
  	}


	resources :products, only: [:index] do
	  resources :orders, only: :create
	end

	resources :orders, only: [:index, :destroy] do
		collection do
			delete 'empty_cart'
		end
	end		

	resources :billings, only: [] do
		collection do
 			get 'pre_pay'
 			get 'execute'
 		end
	end

	root 'products#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
