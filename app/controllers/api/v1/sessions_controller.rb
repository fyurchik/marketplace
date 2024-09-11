class Api::V1::SessionsController < ApplicationController
  skip_before_action :authenticate_user, only: [:create]

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      token = JsonWebTokenService.encode({ email: @user.email })
      render json: { auth_token: token }
    else
      render json: { error: "Incorrect Email or Password" }, status: :unauthorized
    end
  end

  def destroy
    render json: { message: "Logged out successfully" }, status: :ok
  end
end
