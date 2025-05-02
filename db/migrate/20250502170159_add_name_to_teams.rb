class AddNameToTeams < ActiveRecord::Migration[8.0]
  def change
    change_table :teams do |t|
      t.column :name, :string, limit: 120
    end
  end
end
