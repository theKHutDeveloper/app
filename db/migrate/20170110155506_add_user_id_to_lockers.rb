class AddUserIdToLockers < ActiveRecord::Migration[5.0]
  def change
  	add_column :lockers, :user_id, :string
  end
end
