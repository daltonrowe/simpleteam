class CreateData < ActiveRecord::Migration[8.0]
  def change
    create_table :data, id: :string do |t|
      t.belongs_to :team, null: false, index: true, foreign_key: true, type: :string
      t.string :name, null: false, limit: 120
      t.json :content, default: {}, limit: 120
      t.timestamps
    end

    add_index :data, [ :name, :created_at ]
  end
end
