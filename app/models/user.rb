class User < ActiveRecord::Base

  has_secure_password

  # Associations
  has_many :todos

  # Validations
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, email: true
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :password, length: { in: 6..20 }, on: :create
end
