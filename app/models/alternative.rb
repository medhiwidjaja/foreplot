class Alternative < ApplicationRecord
  belongs_to :article
  has_many :properties

  validates :title, presence: true
end
