class AddCRtoAppraisals < ActiveRecord::Migration[5.2]
  def change
    add_column :appraisals, :consistency_ratio, :decimal
  end
end
