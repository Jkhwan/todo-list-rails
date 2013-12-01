class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def destroy
    session[:user_id] = nil
    redirect_to new_session_path
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user
      session[:user_id] = @user.id
      redirect_to todos_path, notice: "Welcome back, #{@user.firstname}!"
    else
      flash[:alert] = "Log in failed"
      render :new
    end
  end
end
