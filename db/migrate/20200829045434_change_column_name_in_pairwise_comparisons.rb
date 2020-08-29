class ChangeColumnNameInPairwiseComparisons < ActiveRecord::Migration[5.2]
  def change
    remove_column :pairwise_comparisons, :ahp_comparison_id
    add_reference :pairwise_comparisons, :appraisal, foreign_key: true
  end
end
