class User < ApplicationRecord
	has_secure_password 
	
	has_many :articles 
	has_many :comments 
	
	validates :name, presence: true, uniqueness: true
	validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP } 
	validates :password, presence: true, length: { minimum: 8 }
end
