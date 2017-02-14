class User < ActiveRecord::Base
	include ActiveModel::SecurePassword
	    has_secure_password

	require 'bcrypt'

	def self.generate_password(password)
		BCrypt::Password.create(password)
	end

	def self.create_user(username,password)
		password = generate_password(password)
		user = User.new(username: username, password_digest: password)
		user.save!
		puts user.inspect
	end
end
