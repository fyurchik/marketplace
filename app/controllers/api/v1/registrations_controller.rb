class Api::V1::RegistrationsController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      render json: { success: "saved"}, status: :ok
    else
      render json: { error: @user.errors.messages.map { |msg, desc|
      msg.to_s + " " + desc[0] }.join(",") }, status: :unauthorized
    end
  end

  private
  
  def user_params
    params.require(:users).permit(:name, :email, :password, :password_confirmation)
  end
end
