class CreateAlternatives < ActiveRecord::Migration[5.2]
  def change
    create_table :alternatives do |t|
      t.string :title
      t.string :description
      t.string :abbrev
      t.integer :position
      t.belongs_to :article, index: true, foreign_key: true

      t.timestamps
    end
  end
end
