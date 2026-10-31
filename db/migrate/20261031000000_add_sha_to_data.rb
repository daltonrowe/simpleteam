class AddShaToData < ActiveRecord::Migration[8.0]
  def change
    add_column :data, :sha, :string, limit: 64
    add_index :data, [ :team_id, :sha ]
  end
end
