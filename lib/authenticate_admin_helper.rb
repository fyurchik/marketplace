module AuthenticateHelper
  def authenticate_admin
    token = request.headers['Authorization']&.split(' ')&.last
    decoded = JsonWebTokenService.decode(token)
    if decoded && decoded['admin']
      @current_admin = Admin.find_by(email: decoded['email'])
    else
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end
end
