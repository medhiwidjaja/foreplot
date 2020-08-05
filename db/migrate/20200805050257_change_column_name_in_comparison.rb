class ChangeColumnNameInComparison < ActiveRecord::Migration[5.2]
  def change
    rename_column :comparisons, :rank_no, :rank
  end
end
