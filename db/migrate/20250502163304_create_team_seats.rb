class CreateTeamSeats < ActiveRecord::Migration[8.0]
  def change
    create_table :team_seats do |t|
      t.belongs_to :team
      t.belongs_to :user, null: true

      t.timestamps
    end
  end
end
