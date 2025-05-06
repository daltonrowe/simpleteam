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
end
