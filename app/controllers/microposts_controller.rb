class MicropostsController < ApplicationController
	before_action :sign_in_user
	before_action :micropost_verify, only: [:destroy]
	def create
		@micropost = current_user.microposts.build(micropost_params)
		if @micropost.save
			flash[:success] = "Micropost pushed!"
			redirect_to root_path
		else
			@feed_items = []
			render 'static_pages/home'
		end
	end
	def destroy
		@micropost = Micropost.find(params[:id])
		@micropost.destroy
		flash[:success] = "Post deleted!"
		redirect_to root_path
	end

	private
		def micropost_params
			params.require(:micropost).permit(:content) #strong parameters
		end
		def micropost_verify
			@micropost = current_user.microposts.find(params[:id])
			redirect_to root_path unless !@micropost.nil? 
		end
end