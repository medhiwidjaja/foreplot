class Article < ApplicationRecord
  validates :title, presence: true 

  belongs_to :user
  has_many :alternatives, dependent: :destroy
  has_many :criteria, dependent: :destroy
  has_many :members, dependent: :destroy

  scope :owned_by, -> (user) { where user: user }

  scope :with_criteria, -> { includes(:criteria) }
  
  after_create :create_goal
  after_create :create_default_member
  after_save :check_goal

  def visibility
    private ? 'Private' : 'Public'
  end

  def delete_completely!
    criteria.destroy_all
    members.delete_all
    self.destroy
  end

  private

  def create_goal
    criteria.create title: title
  end

  def check_goal
    create_goal if criteria.blank?
  end
  
  def create_default_member
    members << Member.create(user:user, role:'owner', active:true, weight:1.0)
  end


end
