class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name, limit: 60
      t.string :email_address, null: false
      t.string :password_digest, null: false
      t.datetime :confirmed_at, null: true

      t.timestamps
    end

    add_index :users, :email_address, unique: true
  end
end
