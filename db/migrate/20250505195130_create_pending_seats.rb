class CreatePendingSeats < ActiveRecord::Migration[8.0]
  def change
    create_table :pending_seats do |t|
      t.belongs_to :team
      t.string :email_address, index: true
      t.string :token, index: true
      t.datetime :expires_at

      t.timestamps
    end
  end
end
