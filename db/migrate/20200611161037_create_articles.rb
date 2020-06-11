class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :description
      t.integer :likes
      t.string :slug
      t.boolean :private
      t.boolean :active

      t.timestamps
    end
  end
end
