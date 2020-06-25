class ChangeTypeInCriteria < ActiveRecord::Migration[5.2]
  def change
    remove_column :criteria, :comparison_type, :integer
    remove_column :criteria, :eval_method, :integer
    
    add_column :criteria, :comparison_type, :string
    add_column :criteria, :eval_method, :string
  end
end
