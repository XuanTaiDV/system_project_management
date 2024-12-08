class AuthToken
  def self.encode_payload(payload)
    payload[:iss] = "SM"
    payload[:iat] = Time.now.to_i

    JWT.encode(payload, nil)
  end

  def self.decode(token)
    raise Exceptions::Unauthorized, "Token is invalid" if token.blank?

    JWT.decode(token, nil, false)
  end

  def self.decode!(token)
    payload, header = decode(token)

    raise Exceptions::Unauthorized, "Token is expired" if header['exp'].to_i > Time.current.to_i

    [payload, header]
  end
end
