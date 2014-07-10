class UsersController < ApplicationController
  before_action :sign_in_user, only: [:edit, :update, :index, :destroy] #means, before excuting edit or update action, call "sign_in_user" method which is defined in the latter part of this page. only:[] is a hash. By default, before action filter applies to all action. Use only to limit the sign in restriction to only edit and update actions. 
  before_action :correct_user, only: [:edit, :update] # with this second filter the previous filter is actually unnecessary. Also, added :show in the restriction list only: []
  before_action :admin_user, only: [:destroy] #call method admin_user before executing :destroy action.
  def index
    @users = User.paginate(page:params[:page])
  end

  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page:params[:page]) #just like index action for users.
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
  def edit
    @user = User.find(params[:id]) #params comes from browser http request. and it's always there. You don't need to define it to use it.
  end
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated!"
      redirect_to @user
    else
      render 'edit'
    end
  end
  def destroy
    @user = User.find(params[:id]).destroy
    flash[:success] = "User deleted!"
    redirect_to users_path
  end

  private
	  def user_params
	  	params.require(:user).permit(:name,:email,:password,:password_confirmation)
      #so..:admin is not permitted because it is too sensitive to be exposed to the wild web
	  end

    def sign_in_user
      if !sign_in?
        flash[:notice] = "Please sign in first."
        store_location
        redirect_to signin_path
        # redirect_to signin_url, notice: "Please sign in first." unless sign_in?
      end
    end

    def correct_user
      @user = User.find(params[:id]) #params[:id] marks the user id requested by the user.
      redirect_to root_url unless @user == current_user
      #the @user requested to be operated on has to equal to the user that was signed in. 
      #note that the reason we can call current_user (a field that belongs to session) is that SessionHelp was included in the application controller. 
    end

    def admin_user
      @user = current_user
      redirect_to root_url unless @user.admin?
    end
end
