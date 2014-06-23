class UsersController < ApplicationController
  def show
  	@user = User.find(params[:id])
  end
  def new
  	@user = User.new
  end
  def create
  	@user = User.new(user_params) # the submission is passed to the User controller as params, a hash with name "user"
  	#params seems to be the bundle in Android dev. It is the basket used to pass bread between activities.
  	if @user.save
      sign_in @user
      flash[:success] = "Welcome to our club! --Junyu Yang, CEO"
      # the same flash display system as in user_controller. 
      # the message is displayed in application.html.erb
      redirect_to @user
  	else
  		render 'new'	
  	end
  end

  private
	  def user_params
	  	params.require(:user).permit(:name,:email,:password,:password_confirmation)
	  end
end
