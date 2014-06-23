module SessionsHelper
	def sign_in(user)
		remember_token = User.new_remember_token
		cookies.permanent[:remember_token] = remember_token #cookies[:remember_token]={value:remember_token,expires:20.years.from_now.utc}
		user.update_attribute(:remember_token, User.digest(remember_token))
		self.current_user = user #(current session).current_user
	end

	def sign_in?
		!current_user.nil? #session.current_user 	
		# If the @current_user is nil, it will extract remember_token from cookie. If there is no remember_token either, that means the user is not signed in. 
	end
	
	def current_user= (user) # "=" means this def only handles assignment. For current_user as a field, the def is below.
														# the "=" has to  
		@current_user = user
	end
	
	def current_user # this is what happens when current_user is being called as a field of the session it belongs to
		remember_token = User.digest(cookies[:remember_token]) #extract the token stored in user's browser's cookie
		@current_user ||= User.find_by(remember_token: remember_token) #if current_user is currently nil, use the token to find the user.
	end
	#why can't sign_in method use the same current_user method as defined in the last block? Why there has to be a separate method set for him?
	# the last block, can I use if @current_user == nil blablabla, else @current_user

	def sign_out
		current_user.update_attribute(:remember_token, User.digest(User.new_remember_token))#here it should not be nil, because nil is a set number. It can be duplicated.
		cookies[:remember_token]=nil
		self.current_user = nil
	end
end


