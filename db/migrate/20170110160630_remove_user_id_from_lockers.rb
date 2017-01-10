class RemoveUserIdFromLockers < ActiveRecord::Migration[5.0]
  def change
  	remove_column :lockers, :user_id, :string
  end
end
