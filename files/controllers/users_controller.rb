class UsersController < ApplicationController
  before_action :set_user, except: [:new, :create]

  # GET /user
  def show
  end

  # GET /users/new
  def new
    @new_user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @new_user = User.new(user_params)
    if @new_user.save
      redirect_to user_path, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def update
    password_validation = params[:user][:password_validation]
    valid_password = @user.valid_password?(password_validation)
    if valid_password && @user.update(user_params)
      redirect_to user_path, notice: 'User was successfully updated.'
    else
      @user.errors.add(:password)
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to root_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password)
    end

end
