class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, 
         :recoverable, :rememberable, :validatable


  validates :name, :account, :role, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, confirmation: true
  validates_length_of :password, minimum: 8, on: :create

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i } 

  has_many :articles
  has_many :votes
  has_many :rankings
  has_many :memberships, class_name: "Member"

  acts_as_followable
  acts_as_follower
end
