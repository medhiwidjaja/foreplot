class Article < ApplicationRecord
  validates :title, presence: true 

  belongs_to :user
  has_many :alternatives, dependent: :destroy
  has_many :criteria, dependent: :destroy
  
  scope :owned_by, -> (user) { where user: user }

  accepts_nested_attributes_for :alternatives
  
  after_create :create_goal

  def visibility
    private ? 'Private' : 'Public'
  end

  private
  def create_goal
    criteria.create title: title
  end

end
