module AuthenticateAdminHelper
  def authenticate_admin
    token = request.headers['Authorization']&.split(' ')&.last
    decoded = JsonWebTokenService.decode(token)
  
    if decoded && decoded['admin']
      @current_admin = Admin.find_by(email: decoded['email'])
      render json: { error: 'Not Authorized' }, status: :unauthorized unless @current_admin
    else
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end
  
end
