class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.string :team_id, null: false
      t.string :kind, null: false
      t.integer :recipient_count, null: false, default: 0

      t.timestamps
    end

    add_index :notifications, :team_id
    add_index :notifications, :created_at
    add_foreign_key :notifications, :teams
  end
end
