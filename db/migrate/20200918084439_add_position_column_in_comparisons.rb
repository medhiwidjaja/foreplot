class AddPositionColumnInComparisons < ActiveRecord::Migration[5.2]
  def change
    add_column :comparisons, :position, :integer
  end
end
