module AuthenticateHelper
  def authenticate_user
    token = fetch_token
    return unless token_valid?(token)

    begin
      decoded_token = JsonWebTokenService.decode(token)
      email = decoded_token[:email]
      @current_user = User.find_by(email: email)
      render json: { error: 'Not Authorized' }, status: :unauthorized unless @current_user
    rescue JWT::DecodeError
      render json: { error: 'Invalid token' }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end

  private

  def fetch_token
    request.headers['Authorization']&.split(' ')&.last
  end

  def token_valid?(token)
    if token.blank?
      render json: { error: 'Token missing' }, status: :unauthorized
      return false
    elsif BlacklistedToken.exists?(token: token)
      render json: { error: 'Token has been blacklisted' }, status: :unauthorized
      return false
    end
    true
  end
end
