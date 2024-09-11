module AuthenticateAdminHelper
  def authenticate_admin
    token = fetch_token
    return unless token_valid?(token)

    begin
      decoded_token = JsonWebTokenService.decode(token)
      if decoded_token && decoded_token['admin']
        @current_admin = Admin.find_by(email: decoded_token['email'])
        render json: { error: 'Not Authorized' }, status: :unauthorized unless @current_admin
      else
        render json: { error: 'Not Authorized' }, status: :unauthorized
      end
    rescue JWT::DecodeError
      render json: { error: 'Invalid token' }, status: :unauthorized
    end
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
