class AuthController < ApplicationController
	 before_action :authenticate_user, except: [:login] 

	def login
		@user = User.find_by(email: params[:email])
		if @user.authenticate(params[:password])
			@user.update(status: :active) unless @user.active?
			token = JsonWebToken.generate_tokens(@user)
			render json: {user: {email: @user.email, status: @user.status} ,access_token: token[:access_token], refresh_token: token[:refresh_token]},status: :ok
		else
			render json: {error: "Invalid email or password"}, status: :unauthorized
		end
	end
end
