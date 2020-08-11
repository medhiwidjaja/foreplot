class Member < ApplicationRecord
  belongs_to :article
  belongs_to :user

  scope :with_user_id, -> (user_id) { where(user_id: user_id) }
  scope :author, -> { where(role: 'owner') }

  validates :user_id, uniqueness: {scope: :article_id}
  
  # There should be only 1 owner
  validates :role, uniqueness: {scope: :article_id}, if: -> { role == 'owner' }

  before_destroy :check_if_owner

  private

  def check_if_owner
    errors.add(:base, "Cannot delete owner member") if role == 'owner'
    throw(:abort) if errors.present?
  end

end
