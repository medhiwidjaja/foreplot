class AdditionalFieldsInAppraisal < ActiveRecord::Migration[5.2]
  def change
    add_column :appraisals, :minimize, :boolean
    add_column :appraisals, :range_min, :decimal
    add_column :appraisals, :range_max, :decimal
    add_column :appraisals, :normalize, :boolean
  end
end
