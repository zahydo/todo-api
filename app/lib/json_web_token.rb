class JsonWebToken
  # Secret to encode and decode token
  HMAC_SECRET = Rails.application.secrets.secret_key_base

  def self.encode(payload, exp = 24.hours.from_now)
    # Set expiry to 24 hours from creation time
    payload[:exp] = exp.to_i
    # Generate the token
    JWT.encode(payload, HMAC_SECRET)
  end

  def self.decode(token)
    # get payload, first index in decoded array
    body = JWT.decode(token, HMAC_SECRET)[0]
    # Create hash by access via hash[:id] or hash["id"]
    HashWithIndifferentAccess.new body
  # rescue from all decode errors
  rescue JWT::DecodeError => e
    # raise custom error to be handled by custom handler
    raise ExceptionHandler::InvalidToken, e.message
  end
end