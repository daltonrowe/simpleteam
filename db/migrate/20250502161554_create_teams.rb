class CreateTeams < ActiveRecord::Migration[8.0]
  def change
    create_table :teams do |t|
      t.string :guid
      t.belongs_to :user, null: false, foreign_key: true
      t.string :name, limit: 120
      t.string :time_zone, default: "Central Time (US & Canada)"

      t.timestamps
    end

    add_index :teams, :guid
  end
end
