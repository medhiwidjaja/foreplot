class ChangeColumnNameInCriteria < ActiveRecord::Migration[5.2]
  def change
    rename_column :criteria, :eval_method, :appraisal_method
  end
end
