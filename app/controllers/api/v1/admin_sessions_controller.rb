class Api::V1::AdminSessionsController < ApplicationController
  before_action :authenticate_admin, only: [:destroy]

  def create
    admin = Admin.find_by(email: params[:email])
    if admin&.authenticate(params[:password])
      token = JsonWebTokenService.encode({ email: admin.email, admin: true })
      render json: { auth_token: token }, status: :ok
    else
      render json: { error: "invalid email or password" }, status: :unauthorized
    end
  end

  def destroy
    token = request.headers['Authorization']&.split(' ')&.last
    if BlacklistedToken.create(token: token)
      render json: {message: "user logged out and session destroyed" }, status: :ok
    else
      render json: {error: "nable to log out"}, status: :unprocessable_entity
    end
  end
end
