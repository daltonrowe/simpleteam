class RenameNotifactionTime < ActiveRecord::Migration[8.0]
  def change
    rename_column :teams, :notifaction_time, :notification_time
    change_column :teams, :notification_time, :time
  end
end
