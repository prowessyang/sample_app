class SessionsController < ApplicationController
	def new
	end
	
	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			# @user = user
			# render 'users/show'
			# using render works but if user refreshes the page, the submission repeats. Use redirect_to instead.
			sign_in user #sign_in method can be found in sessions_helper
			redirect_back_or user
		else
			flash.now[:error] = 'Invalid email/password combination'
			render 'new'
		end
	end
	
	def destroy
		sign_out
		redirect_to signin_path # root_path in the book
	end
end
