class RenameColumnNoInLockerToLockerId < ActiveRecord::Migration[5.0]
  def change
  	rename_column :lockers, :no, :locker_id
  end
end
