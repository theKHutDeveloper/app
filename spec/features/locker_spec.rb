require File.dirname(__FILE__) + '/../rails_helper'
require File.dirname(__FILE__) + '/../../test/test_helper.rb'

def create_admin
	@user = User.create email:"jj@test.com", password: "password", 
	firstname: "jessica", lastname: "jones", admin: "true"
end


def create_user
	@non_admin = User.create email: "ironman@stark.industries.com", 
	password: "jarvis", firstname: "tony", lastname: "stark", admin: "false"
end


def log_in(email, password)
	visit root_path
	click_link('Log In')
	fill_in 'Email', with: email
	fill_in('Password', with: password, match: :prefer_exact)
  	click_button 'Log in'
end


RSpec.feature 'Testing functionality of the Locker features' do

	scenario 'User views available lockers' do
		#completed in welcome_spec.rb
	end

	scenario 'User requests to be assigned a locker' do
		create_user
		log_in(@non_admin.email, @non_admin.password)
		visit root_path
		page.click_link('', :href => '/locker?status=Free')
		click_button('Request This Locker')
		expect(page).to have_content("Your request has been sent")
	end

	scenario 'User attempts to amend assigned locker' do
	end

	scenario 'User views their assigned locker' do
		create_user
		log_in(@non_admin.email, @non_admin.password)
		visit root_path
		page.click_link('', :href => '/user/show')
	end

	scenario 'User requests to remove their assigned locker' do
	end

	scenario 'Admin views all lockers' do
	end

	scenario 'Admin edits a locker' do
	end

	scenario 'Admin deletes a free locker' do
	end

	scenario 'Admin deletes an assigned locker' do
	end

	scenario 'Admin assigns a locker to a user' do
	end
end