module AuthHelper
  def generate_token(user, admin = false)
    payload = {
      email: user.email,
      admin: admin,
      exp: (Time.now + 2.hours).to_i
    }
    JsonWebTokenService.encode(payload)
  end

  def auth_header(user, admin = false)
    token = generate_token(user, admin)
    { "Authorization" => "Bearer #{token}" }
  end
end
