class JsonWebTokenService
  SECRET_KEY = Rails.application.credentials.secret_key_base

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  def self.decode(token)
    body = JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256')[0]
    HashWithIndifferentAccess.new(body)
  rescue JWT::ExpiredSignature
    raise "token has expired"
  rescue JWT::DecodeError, JSON::ParserError
    raise "Invalid token"
  end
end
