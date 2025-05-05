class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :teams
  has_many :seats

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
