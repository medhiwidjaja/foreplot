module ArticleConcern 
  extend ActiveSupport::Concern

  included do
    before_action :set_member, if: :member_required?
  end

  private

  def member_required?
    true
  end

  def set_member
    @member = Member.find(member_param)
  end

  def member_param
    params[:member_id]
  end
end 