module EncryptionHelper
  def encrypt(text)
    cipher = OpenSSL::Cipher.new("aes-256-cbc").encrypt
    cipher.key = Digest::MD5.hexdigest Rails.application.credentials.encryption_secret_key
    s = cipher.update(text) + cipher.final

    s.unpack("H*")[0].upcase
  end

  def decrypt(text)
    cipher = OpenSSL::Cipher.new("aes-256-cbc").decrypt
    cipher.key = Digest::MD5.hexdigest Rails.application.credentials.encryption_secret_key
    s = [ text ].pack("H*").unpack("C*").pack("c*")

    cipher.update(s) + cipher.final
  end

  def user_token(email_address, expires_at, purpose)
    encrypt "#{email_address}---#{expires_at}---#{purpose}"
  end

  def valid_user_token(email_address, token, purpose)
    data = decrypt(token)
    token_email, token_date, token_purpose = data.split("---")

    email_valid = token_email == email_address
    time_valid = DateTime.parse(token_date).future?
    purpose_valid = token_purpose == purpose

    email_valid && time_valid && purpose_valid
  end

  def user_token_data(token)
    data = decrypt(token)
    token_email, token_date, token_purpose = data.split("---")

    { token_email:, token_date:, token_purpose:, token: }
  end
end
