class Article < ApplicationRecord
  validates :title, presence: true 

  belongs_to :user

  scope :owned_by, -> (user) { where user: user }

  def visibility
    private ? 'Private' : 'Public'
  end
end
