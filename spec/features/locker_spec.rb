require File.dirname(__FILE__) + '/../rails_helper'
require File.dirname(__FILE__) + '/../../test/test_helper.rb'

def create_admin
	@user = User.create email:'jj@test.com', password: 'password', 
	firstname: 'jessica', lastname: 'jones', admin: 'true'
end


def create_user
	@non_admin = User.create email: 'ironman@stark.industries.com', 
	password: 'jarvis', firstname: 'tony', lastname: 'stark', admin: 'false'
end

def log_in(email, password)
	visit root_path
	click_link('Log In')
	fill_in 'Email', with: email
	fill_in('Password', with: password, match: :prefer_exact)
  	click_button 'Log in'
end

def create_single_locker
	@locker = Locker.create(ref: 'G001', floor: 3, location: 'Verify Team', shared: false, size: 1, status: 'Free')
end

RSpec.feature 'Testing functionality of the Locker features' do

#failing
	scenario ' - User requests to be assigned a locker' do
		#being able to test the alert box is a problem
		create_single_locker
		create_user
		log_in(@non_admin.email, @non_admin.password)
		visit root_path
		page.click_link('', :href => '/locker?status=Free')
		click_link('Request This Locker')
		expect(page).to have_content('Your request has been sent!')
	end


	scenario 'User attempts to amend assigned locker' do
		create_user
		log_in(@non_admin.email, @non_admin.password)
		visit root_path
		visit locker_index_path
		expect(page).to have_content('You do not have permission to access this page')
	end

	scenario 'User views their assigned locker' do
		create_user
		log_in(@non_admin.email, @non_admin.password)
		visit root_path
		page.click_link('', :href => '/user/show')
	end

	scenario 'User requests to remove their assigned locker' do
	
	end

	scenario 'Admin creates a new locker' do
		create_admin
		log_in(@user.email, @user.password)
		visit root_path
		page.click_link('', :href => '/admin_simple/index')
		click_link('Create a new locker')
		fill_in 'Ref', :with => 'GO20'
		fill_in 'Floor', :with => '3'
		fill_in 'Location', :with => 'Verify Team'
		fill_in 'Size', :with => '3'
		click_button('Create Locker')
		expect(page).to have_content('You successfully created a new locker')
	end

	scenario 'Admin views all lockers' do
	end

	scenario 'Admin edits a locker' do
		create_single_locker
		create_user
		create_admin
		log_in(@user.email, @user.password)
		visit root_path
		page.click_link('', :href => '/admin_simple/index')
		click_link('Edit lockers')
		click_link('Assign Locker')
		click_link('Edit Locker')
		fill_in 'Floor', :with => '30001'
		click_button('Update Locker')
		expect(page).to have_content('30001')
		expect(page).to have_content('You successfully updated locker G001')
	end

	scenario 'Admin deletes a free locker' do
		create_single_locker
		create_user
		create_admin
		log_in(@user.email, @user.password)
		visit root_path
		page.click_link('', :href => '/admin_simple/index')
		click_link('Edit lockers')
		click_link('Assign Locker')
		click_link('Edit Locker')
		click_link('Delete Locker')
		expect(page).to have_content('Locker has been deleted')
	end

	scenario 'Admin deletes an assigned locker' do
	end

	scenario 'Admin assigns a locker to a user' do
		create_single_locker
		create_user
		create_admin
		log_in(@user.email, @user.password)
		visit root_path
		page.click_link('', :href => '/admin_simple/index')
		click_link('Edit lockers')
		click_link('Assign Locker')
		select @non_admin.email, :from => @users
		click_button('Update Locker')
		expect(page).to have_content('ironman@stark.industries.com has been successfully assigned to locker G001')
	end

	scenario '- Admin removes user from locker' do
		create_single_locker
		create_user
		create_admin
		log_in(@user.email, @user.password)
		visit root_path
		page.click_link('', :href => '/admin_simple/index')
		click_link('Edit lockers')
		click_link('Assign Locker')
		select @non_admin.email, :from => @users
		click_button('Update Locker')
		click_link('Home')
		page.click_link('', :href => '/admin_simple/index')
		click_link('Edit lockers')
		click_link('Edit Locker')
		click_link('Delete')
		expect(page).to have_content('ironman@stark.industries.com has been removed from locker G001')
	end
end