class AddLockerIdToUser < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :locker_id, :integer
  end
end
