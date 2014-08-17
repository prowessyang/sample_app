class RelationshipsController < ApplicationController
	before_action :sign_in_user
	def create
		@user = User.find(params[:relationship][:followed_id])
		current_user.follow!(@user) # stack overflow?
		
		respond_to do |format| # executing 1 of 2
			format.html {redirect_to @user}
			format.js
		end
		# redirect_to @user
	end

	def destroy
		@user = Relationship.find(params[:id]).followed
		current_user.unfollow!(@user)
		respond_to do |format|
			format.html {redirect_to @user}
			format.js
		end
	end
end