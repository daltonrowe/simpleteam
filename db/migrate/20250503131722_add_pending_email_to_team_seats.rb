class AddPendingEmailToTeamSeats < ActiveRecord::Migration[8.0]
  def change
    change_table :team_seats do |t|
      t.column :pending_email, :string, null: true
    end
  end
end
