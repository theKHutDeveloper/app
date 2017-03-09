#user_spec.rb
require 'rails_helper'

describe User do

	fixtures :users

#This does not work, due to the password
	it 'tests the basic functionality of the user' do
		new_user = User.new email: users(:one).email, 
		encrypted_password: users(:one).encrypted_password, 
		firstname: users(:one).firstname, 
		lastname: users(:one).lastname,
  		admin: users(:one).admin 

  		assert new_user.save!

  		user_copy = User.find(new_user.id)
  		assert_equal new_user, user_copy

  		new_user.firstname = 'Pepper'
  		assert new_user.save

  		assert new_user.destroy
	end
end