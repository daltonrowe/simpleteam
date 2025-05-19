class CreateTeams < ActiveRecord::Migration[8.0]
  def change
    create_table :teams, id: :string do |t|
      t.belongs_to :user, null: false, foreign_key: true, type: :string
      t.string :name, limit: 120
      t.json :sections, default: [
        { name: "Yesterday" },
        { name: "Today" },
        { name: "Links", description: "Read anything good?" }
      ]
      t.datetime :notifaction_time, default: "Sat, 17 May 2025 09:30:00 +0000"
      t.datetime :end_of_day, null: false, default: "Sat, 17 May 2025 15:00:00 +0000"
      t.string :time_zone, default: "Central Time (US & Canada)"
      t.json :metadata, default: {}

      t.timestamps
    end
  end
end
