class CreateStatuses < ActiveRecord::Migration[8.0]
  def change
    create_table :statuses, id: :string do |t|
      t.belongs_to :team, null: false, index: true, foreign_key: true, type: :string
      t.belongs_to :user, null: false, index: true, foreign_key: true, type: :string
      t.json :sections

      t.timestamps
    end

    add_index :statuses, :created_at
  end
end
