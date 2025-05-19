class CreateSeats < ActiveRecord::Migration[8.0]
  def change
    create_table :seats do |t|
      t.belongs_to :team, null: false, index: true, foreign_key: true, type: :string
      t.belongs_to :user, null: false, index: true, foreign_key: true, type: :string

      t.timestamps
    end
  end
end
