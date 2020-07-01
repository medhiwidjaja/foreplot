class CreateComparisons < ActiveRecord::Migration[5.2]
  def change
    create_table :comparisons do |t|
      t.integer :comparable_id
      t.string :comparable_type
      t.string :title
      t.string :notes
      t.decimal :score
      t.decimal :score_n
      t.string :comparison_method
      t.decimal :value
      t.string :unit
      t.integer :rank_no
      t.string :rank_method
      t.decimal :consistency

      t.timestamps
    end
    add_index :comparisons, [:comparable_type, :comparable_id]
  end
end
