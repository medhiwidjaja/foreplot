class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :encrypted_password
      t.string :email
      t.string :bio
      t.string :account
      t.string :role

      t.timestamps
    end
  end
end
