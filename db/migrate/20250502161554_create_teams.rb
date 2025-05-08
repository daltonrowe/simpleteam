class CreateTeams < ActiveRecord::Migration[8.0]
  def change
    create_table :teams do |t|
      t.string :name, limit: 120
      t.string :guid
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :teams, :guid
  end
end
