class Api::V1::AdminSessionsController < ApplicationController
  before_action :authenticate_admin, only: [:destroy]

  def create
    admin = Admin.find_by(email: params[:email])
    if admin&.authenticate(params[:password])
      token = JsonWebTokenService.encode({ email: admin.email, admin: true })
      render json: { auth_token: token }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def destroy
    render json: { message: "Logged out successfully" }, status: :ok
  end
end
