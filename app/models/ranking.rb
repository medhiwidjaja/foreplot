class Ranking < ApplicationRecord
  belongs_to :article
  belongs_to :user
  belongs_to :vote
  belongs_to :alternative
end
