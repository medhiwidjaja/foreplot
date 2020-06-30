class Vote < ApplicationRecord
  belongs_to :article
  belongs_to :user
  belongs_to :member
  has_many :rankings
end
