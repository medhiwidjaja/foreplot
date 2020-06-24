class AddParentColumnInCriteria < ActiveRecord::Migration[5.2]
  def change
    add_column :criteria, :parent_id, :integer, null: true, index: true
  end
end
