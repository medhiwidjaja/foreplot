class AddAppraisalIdToComparison < ActiveRecord::Migration[5.2]
  def change
    add_reference :comparisons, :appraisal, foreign_key: true
  end
end
