class CreateRankings < ActiveRecord::Migration[5.2]
  def change
    create_table :rankings do |t|
      t.belongs_to :article, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.belongs_to :vote, foreign_key: true
      t.string :type
      t.belongs_to :alternative, foreign_key: true
      t.decimal :score
      t.integer :rank_no
      t.string :notes

      t.timestamps
    end
  end
end
