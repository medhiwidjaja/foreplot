class CreateCriteria < ActiveRecord::Migration[5.2]
  def change
    create_table :criteria do |t|
      t.string :title
      t.string :abbrev
      t.string :description
      t.boolean :cost
      t.boolean :active
      t.integer :comparison_type
      t.integer :eval_method
      t.string :property_name
      t.integer :position
      
      t.timestamps
    end
  end
end
