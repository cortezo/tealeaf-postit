class ChangeUsersTimezoneFromTimezoneToString < ActiveRecord::Migration
  def change
    change_column :users, :timezone, :string
  end
end
