class SessionsController < ApplicationController
  	
  	def new
		@user = User.new
		@is_login = true
		if current_user
			redirect_to product_specs_path
		end
	end

	def create
		u = User.where(username: params[:user][:username]).first
		if u && u.authenticate(params[:user][:password])
			session[:user_id] = u.id.to_s
				redirect_to product_specs_path
			else
				# Go back to the login page
				redirect_to root_path
		end
	end





	def destroy
		reset_session
		redirect_to root_path
	end
end
