class User < ApplicationRecord
	has_secure_password
	has_many :tasks, dependent: :destroy

	enum status: {inactive: 0, active: 1}

	validates :name, presence: true
	validates :email, presence: true
	validates :phone, presence: true, uniqueness: true
	validates :password, presence: true

end
