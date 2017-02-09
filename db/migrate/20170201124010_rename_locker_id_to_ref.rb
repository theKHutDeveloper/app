class RenameLockerIdToRef < ActiveRecord::Migration[5.0]
  def change
  	rename_column :lockers, :locker_id, :ref
  end
end
