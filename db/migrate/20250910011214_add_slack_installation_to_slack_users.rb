class AddSlackInstallationToSlackUsers < ActiveRecord::Migration[8.0]
  def change
    add_reference :slack_users, :slack_installation, index: true, foreign_key: true, type: :string
  end
end
