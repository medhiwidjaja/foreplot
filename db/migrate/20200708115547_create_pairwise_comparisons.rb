class CreatePairwiseComparisons < ActiveRecord::Migration[5.2]
  def change
    create_table :pairwise_comparisons do |t|
      t.integer :comparable1_id
      t.string :comparable1_type
      t.integer :comparable2_id
      t.string :comparable2_type
      t.belongs_to :ahp_comparison
      t.decimal :value

      t.timestamps
    end
  end
end
