class CreateProperties < ActiveRecord::Migration[5.2]
  def change
    create_table :properties do |t|
      t.belongs_to :article, index: true, foreign_key: true
      t.belongs_to :alternative, index: true, foreign_key: true
      t.string :name
      t.decimal :value
      t.string :unit
      t.boolean :is_cost
      t.boolean :is_common
      t.string :description

      t.timestamps
    end
  end
end
