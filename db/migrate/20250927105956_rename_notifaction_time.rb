class RenameNotifactionTime < ActiveRecord::Migration[8.0]
  def up
    rename_column :teams, :notifaction_time, :notification_time
    change_column :teams, :notification_time, :time, default: "14:30:00 +0000"
  end

  def down
    rename_column :teams, :notification_time, :notifaction_time
    change_column :teams, :notifaction_time, :datetime, default: "Sat, 17 May 2025 09:30:00 +0000"
  end
end
