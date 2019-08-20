class AuthorizeApiRequest
  def initialize(headers = {})
    @headers = headers
  end

  #Service entry point - return valid user object
  def call
    {
      user: user
    }
  end
  
  private
  
  attr_reader :headers # read access only
    
  def user
    # Check if the user is in the database
    # Memorize user object
    @user ||= User.find(decode_auth_token[:user_id]) if decode_auth_token
  rescue ActiveRecord::RecordNotFound => e
    # Raise custom error
    raise(ExceptionHandler::InvalidToken, ("#{Message.invalid_token} #{e.message}"))
  end
  
  # Decode authentication token
  def decode_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  # Check for token in 'Authorization' header
  def http_auth_header
    if headers['Authorization'].present?
      return headers['Authorization']
    else
      raise(ExceptionHandler::MissingToken, 'Missing token')
    end
  end
  
  
end