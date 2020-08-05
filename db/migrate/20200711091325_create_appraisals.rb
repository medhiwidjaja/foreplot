class CreateAppraisals < ActiveRecord::Migration[5.2]
  def change
    create_table :appraisals do |t|
      t.belongs_to :criterion, foreign_key: true
      t.belongs_to :member, foreign_key: true
      t.boolean :is_valid
      t.string :appraisal_method
      t.boolean :is_complete

      t.timestamps
    end
  end
end
