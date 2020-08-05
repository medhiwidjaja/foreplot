class Member < ApplicationRecord
  belongs_to :article
  belongs_to :user

  scope :with_user_id, -> (user_id) { where(user_id: user_id) }
  scope :author, -> { where(role: 'owner') }
end
