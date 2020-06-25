class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.belongs_to :article, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.belongs_to :member, foreign_key: true
      t.decimal :weight
      t.decimal :weight_n

      t.timestamps
    end
  end
end
