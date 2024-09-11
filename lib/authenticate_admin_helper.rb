module AuthenticateAdminHelper
  def authenticate_admin
    token = request.headers['Authorization']&.split(' ')&.last
    decoded = JsonWebTokenService.decode(token)
  
    if decoded
      puts decoded # This will log the decoded token
    end
  
    if decoded && decoded['admin']
      @current_admin = Admin.find_by(email: decoded['email'])
      puts @current_admin.inspect # Temporary debugging line
      unless @current_admin
        render json: { error: 'Not Authorized - Admin not found' }, status: :unauthorized
      end
    else
      render json: { error: 'Not Authorized - Admin flag missing' }, status: :unauthorized
    end
  end
  
end
