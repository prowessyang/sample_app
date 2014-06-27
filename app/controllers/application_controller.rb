class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  #including SessionHelper in Application controller makes sure the methods in Session_helper.rb are available across the application. 
end
