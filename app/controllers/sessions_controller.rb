class SessionsController < ApplicationController
  def new
  end
  def create
    user = User.authenticate(params[:session][:user_name])
    if user.nil?
      flash.now[:error] = "Invalid user name."
      render 'new'
    else
      sign_in user
      redirect_to user
    end
  end
end
