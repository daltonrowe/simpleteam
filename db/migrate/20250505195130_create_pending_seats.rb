class CreatePendingSeats < ActiveRecord::Migration[8.0]
  def change
    create_table :pending_seats do |t|
      t.belongs_to :team, index: true, foreign_key: true, type: :uuid
      t.string :email_address
      t.string :token
      t.datetime :expires_at

      t.timestamps
    end

    add_index :pending_seats, :email_address
    add_index :pending_seats, :token
  end
end
