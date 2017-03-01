require 'test_helper'

class LockerTest < ActiveSupport::TestCase
	fixtures :lockers

	def test_locker
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