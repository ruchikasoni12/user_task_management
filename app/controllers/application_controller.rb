class ApplicationController < ActionController::Base
	protect_from_forgery with: :null_session  # Disable CSRF for API requests

	def authenticate_user
		header = request.headers["token"]
		token = header.split.last if header
		begin
	    decoded = JsonWebToken.decode(token)
	    @current_user = User.find(decoded["user_id"])
		rescue ActiveRecord::RecordNotFound
		    render json: { error: "User not found" }, status: :unauthorized
		rescue JWT::DecodeError
		    render json: { error: "Invalid token" }, status: :unauthorized
		rescue StandardError => e
	    render json: { error: "Authentication failed: #{e.message}" }, status: :unauthorized
	    end
	end
end
