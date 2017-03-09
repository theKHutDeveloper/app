require 'rails_helper'

describe Locker do

	fixtures :lockers

	it 'tests the available scope' do
  		locker_one = Locker.new ref: lockers(:one).ref, floor: lockers(:one).floor, location: lockers(:one).location,
  		shared: lockers(:one).shared, size: lockers(:one).size, status: lockers(:one).status

  		locker_one.save

  		locker_two = Locker.new ref: lockers(:one).ref, floor: lockers(:one).floor, location: lockers(:one).location,
  		shared: lockers(:one).shared, size: lockers(:one).size, status: lockers(:one).status

  		locker_two.save

  		locker_three = Locker.new ref: lockers(:three).ref, floor: lockers(:three).floor, location: lockers(:three), 
  		shared: lockers(:three).shared, size: lockers(:three).size, status: lockers(:three).status

  		locker_three.save

  		@available = Locker.available.count
  		assert @available = 1 
  	end

	it 'tests the functionality of the locker' do
		new_locker = Locker.new ref: lockers(:one).ref, floor: lockers(:one).floor, location: lockers(:one).location,
  		shared: lockers(:one).shared, size: lockers(:one).size, status: lockers(:one).status

  		assert new_locker.save

  		locker_copy = Locker.find(new_locker.id)
  		assert_equal new_locker, locker_copy

  		new_locker.ref = 'G390'
  		assert new_locker.save

  		assert new_locker.destroy
	end
end