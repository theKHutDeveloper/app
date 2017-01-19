require File.dirname(__FILE__) + '/../rails_helper'
require File.dirname(__FILE__) + '/../../test/test_helper.rb'


def createAdmin
	@user = User.create email:'jj@test.com', password: 'password', firstname: "jessica", lastname: "jones", admin: "true"
end


def createUser
	@non_admin = User.create email: 'ironman@stark.industries.com', password: 'jarvis', firstname: 'tony', lastname: 'stark', admin: 'false'
end


def logIn(email, password)
	visit root_path
	click_link('Log In')
	fill_in 'Email', with: email
	fill_in('Password', with: password, match: :prefer_exact)
  	click_button 'Log in'
end


RSpec.feature 'Testing functionality of the User features' do

	scenario 'Non-admin user views their details' do
		createUser
		logIn(@non_admin.email, @non_admin.password)
		page.click_link('', :href => '/user/show')
		expect(page).to have_content("My Account Details")
		expect(page).to have_content('Basic')
	end


	scenario 'Non-admin user edits their password' do
		createUser
		logIn(@non_admin.email, @non_admin.password)
		page.click_link('', :href => '/user/show')
		click_link('Edit')
		fill_in('Password', :with => 'newPassword', :match => :prefer_exact)
		fill_in('Password confirmation', :with => 'newPassword', :match => :prefer_exact)
		fill_in('Current password', :with => @non_admin.password, :match => :prefer_exact)
		click_button('Update')

		expect(page).to have_content('Your account has been updated successfully')
	end

	scenario 'Admin user edits their lastname' do
		createAdmin
		logIn(@user.email, @user.password)
		page.click_link('', href: '/user/show')
		click_link('Edit')
		fill_in 'Lastname', with: 'dynamite-jones'
		fill_in('Current password', with: @user.password, match: :prefer_exact)
		click_button('Update')

		expect(page).to have_content('Your account has been updated successfully')
	end

	scenario 'Admin user views all users details' do
		createAdmin
		logIn(@user.email, @user.password)
		page.click_link('', :href => '/admin_simple/index')
		click_link('Edit users')
		expect(current_path).to eq '/users'
 	end


	scenario 'Admin user edits a users firstname' do
		createMultipleUsers
		createAdmin
		logIn(@user.email, @user.password)
		page.click_link('', :href => '/admin_simple/index')
		click_link('Edit users')
		click_link(@three.email)
		fill_in 'Firstname', :with => 'frankie'
		click_button('Update User')

		expect(page).to have_content('You successfully updated a user') 
	end


	scenario 'Admin amends a user account to Admin status' do
		createMultipleUsers
		createAdmin
		logIn(@user.email, @user.password)
		page.click_link('', :href => '/admin_simple/index')
		click_link('Edit users')
		click_link(@two.email)
		check('Admin')
		click_button('Update User')

		expect(page).to have_content('You successfully updated a user')
	end

	
	scenario 'admin invites a potential user' do
		createAdmin
		logIn(@user.email, @user.password)
		page.click_link('', :href => '/admin_simple/index')
		click_link('Invite a user')
	end

	
	scenario 'admin user deletes a single user' do
		createAdmin
		logIn(@user.email, @user.password)
		page.click_link('', :href => '/admin_simple/index')
		click_link('Edit users')
		click_link('Delete', match: :first)
		expect(page).to have_content('You successfully deleted a user')
	end

end