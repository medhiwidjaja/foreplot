class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, confirmation: true
  validates_length_of :password, minimum: 8, on: :create

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i } 

  has_many :articles
  has_many :votes
  has_many :rankings
  has_many :memberships, class_name: "Member"

end
