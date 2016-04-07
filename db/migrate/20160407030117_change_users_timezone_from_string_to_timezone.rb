class ChangeUsersTimezoneFromStringToTimezone < ActiveRecord::Migration
  def change
    change_column :users, :timezone, :timezone
  end
end
