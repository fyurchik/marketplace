module AuthenticateHelper
  def authenticate_user
    token = request.headers['Authorization']&.split(' ')&.last
    if token.present?
      begin
        decoded_token = JsonWebTokenService.decode(token)
        email = decoded_token[:email]
        @current_user = User.find_by(email: email)
        render json: { error: 'Not Authorized' }, status: :unauthorized unless @current_user
      rescue JWT::DecodeError
        render json: { error: 'Invalid token' }, status: :unauthorized
      end
    else
      render json: { error: 'Token missing' }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end
end
