class ChangeUsersTimezoneFromStringToTimezone3 < ActiveRecord::Migration
  def change
    change_column :users, :timezone, :timezone
  end
end
