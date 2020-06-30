class Alternative < ApplicationRecord
  belongs_to :article
  has_many :properties
  has_many :rankings
  validates :title, presence: true
  
end
