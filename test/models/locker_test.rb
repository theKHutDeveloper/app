require 'test_helper'

class LockerTest < ActiveSupport::TestCase
	test "the truth" do
      assert true
  	end

  	test 'available scope' do
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
end
