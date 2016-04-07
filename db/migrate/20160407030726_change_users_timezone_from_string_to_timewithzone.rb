class ChangeUsersTimezoneFromStringToTimewithzone < ActiveRecord::Migration
  def change
    change_column :users, :timezone, :timewithzone
  end
end
