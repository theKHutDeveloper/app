class CreateLockers < ActiveRecord::Migration[5.0]
  def change
    create_table :lockers do |t|
      t.string :no
      t.integer :floor
      t.string :location
      t.boolean :shared
      t.integer :size
      t.string :status

      t.timestamps
    end
  end
end
