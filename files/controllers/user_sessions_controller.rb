class UserSessionsController < ApplicationController
  before_action :require_no_user, except: [:destroy]

  def new
    @user_session = UserSession.new
  end

  # Handles log in request
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      redirect_to user_path
    else
      render action: :new
    end
  end

  # Handles log out request
  def destroy
    current_user_session.destroy
    redirect_to root_url
  end
  
  private

    def require_no_user
      redirect_to user_path if current_user
    end

end