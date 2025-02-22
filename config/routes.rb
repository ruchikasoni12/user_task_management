Rails.application.routes.draw do
  post "/register", to: "users#register"
  post "/login", to: "auth#login" 
  resources :tasks, only: [:create, :index, :show, :update, :destroy]
end



# Rails.application.routes.draw do
#   resources :users, only: [] do
#     collection do
#       post :register  # Maps to UsersController#register
#       post :login, controller: :auth  # Maps to AuthController#login
#     end
#   end
# end
