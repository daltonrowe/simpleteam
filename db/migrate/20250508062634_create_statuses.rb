class CreateStatuses < ActiveRecord::Migration[8.0]
  def change
    create_table :statuses do |t|
      t.belongs_to :team, null: false, index: true, foreign_key: true
      t.belongs_to :user, null: false, index: true, foreign_key: true
      t.json :message
      t.json :links

      t.datetime :updated_at
      t.datetime :created_at
    end

    add_index :statuses, :created_at
  end
end
