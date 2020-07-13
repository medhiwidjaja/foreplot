class CreateAssays < ActiveRecord::Migration[5.2]
  def change
    create_table :assays do |t|
      t.belongs_to :criterion, foreign_key: true
      t.belongs_to :member, foreign_key: true
      t.boolean :is_valid
      t.string :assay_method
      t.boolean :is_complete

      t.timestamps
    end
  end
end
