class ConvertUserLockerIdTypeToInteger < ActiveRecord::Migration[5.0]
  def change
  	change_column :users, :locker_id, :integer
  end
end
