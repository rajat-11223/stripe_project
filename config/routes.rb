Rails.application.routes.draw do
  resources :donations, except: [:show,:edit]
  devise_for :users, controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations',
        passwords: 'users/passwords'
      }

post "refund_popup" => "donations#refund_popup"
post "refund_donation" => "donations#refund_donation"
post "proceed_donation" => "donations#proceed_donation"
post "submit_donation" => "donations#submit_donation"


   root to: "donations#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
