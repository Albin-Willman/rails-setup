class UserSessionsController < ApplicationController

  def new
    @user_session = UserSession.new
  end

  # Handles log in request
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      redirect_to user_url
    else
      render action: :new
    end
  end

  # Handles log out request
  def destroy
    current_user_session.destroy
    redirect_to root_url
  end

end