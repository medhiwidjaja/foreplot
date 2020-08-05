class Ranking < ApplicationRecord
  belongs_to :article
  belongs_to :user
  belongs_to :member
  belongs_to :alternative
end
