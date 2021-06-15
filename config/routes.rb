Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/', to: 'admin#welcome'
  resources :admin, only: [:index]

  namespace :admin do
   resources :merchants, except: [:delete, :put]
   resources :invoices, except: [:delete, :put]
   patch '/merchants', to: 'merchants#update_status'
  end

  resources :merchants, only: [:show] do
    get '/dashboard', to: 'dashboard#show'
    scope module: :merchants do
      resources :items
      resources :invoices, only: [:index, :show]
      resources :invoice_items, only: :update
      resources :bulk_discounts, except: [:put]
    end
  end
end
