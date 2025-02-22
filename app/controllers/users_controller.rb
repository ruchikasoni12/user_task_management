class UsersController < ApplicationController
	 before_action :authenticate_user, except: [:register] 

	def register
		@user = User.new(user_params)
		if @user.save
			render json: {user: UserSerializer.new(@user) , message: "User has successfully registered"}, status: :created
		else
			render json: {error: @user.errors.full_messages}, status: :unprocessable_entity
		end
	end

	private

	def user_params
		params.permit(:name, :email, :phone, :password, :password_confirmation)
	end
end
