class Api::V1::SessionsController < ApplicationController
  before_action :authenticate_user, only: [:destroy]

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      token = JsonWebTokenService.encode({ email: @user.email })
      render json: { auth_token: token }
    else
      render json: { error: "Incorrect Email or Password"}, status: :unauthorized
    end
  end

  def destroy
    token = request.headers['Authorization']&.split(' ')&.last
    if BlacklistedToken.create(token: token)
      render json: { message:"User logged out and session destroyed" }, status: :ok
    else
      render json: { error: "Unable to log out" }, status: :unprocessable_entity
    end
  end
end
