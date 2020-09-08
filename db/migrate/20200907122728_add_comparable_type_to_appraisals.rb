class AddComparableTypeToAppraisals < ActiveRecord::Migration[5.2]
  def change
    add_column :appraisals, :comparable_type, :string
  end
end
