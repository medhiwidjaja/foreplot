class AddAssayIdToComparison < ActiveRecord::Migration[5.2]
  def change
    add_reference :comparisons, :assay, foreign_key: true
  end
end
