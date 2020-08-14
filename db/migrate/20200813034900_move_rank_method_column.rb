class MoveRankMethodColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :appraisals, :rank_method, :string
    remove_column :comparisons, :rank_method, :string
  end
end
