class JsonWebToken
	SECRET_KEY = Rails.application.secret_key_base

	ACCESS_TOKEN_EXPIRY = 30.minutes.from_now
	REFRESH_TOKEN_EXPIRY = 7.days.from_now

	def self.generate_tokens(user)
		{
			access_token: encode({user_id: user.id},ACCESS_TOKEN_EXPIRY ),
			refresh_token: encode({user_id: user.id},REFRESH_TOKEN_EXPIRY )
		}
	end

	def self.encode(payload, exp)
		payload[:exp] = exp.to_i
		JWT.encode(payload, SECRET_KEY)
	end

	def self.decode(token)
		decoded_token = JWT.decode(token, SECRET_KEY)[0]
		HashWithIndifferentAccess.new(decoded_token)
	rescue JWT::ExpiredSignature
		raise StandardError, "Token has expired"
	rescue JWT::DecodeError
		raise StandardError, "Invalid token"
	end
end