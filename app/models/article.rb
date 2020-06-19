class Article < ApplicationRecord
  validates :title, presence: true 

  belongs_to :user
  has_many :alternatives
  
  scope :owned_by, -> (user) { where user: user }

  def visibility
    private ? 'Private' : 'Public'
  end
end
