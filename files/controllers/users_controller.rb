class UsersController < ApplicationController
  before_action :set_user

  # GET /user
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = current_user
    end
end
