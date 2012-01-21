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
      redirect_back_or user
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
