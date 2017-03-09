require File.dirname(__FILE__) + '/../rails_helper'
require File.dirname(__FILE__) + '/../../test/test_helper.rb'

def create_admin
	@admin = User.create email:'jj@test.com', password: 'password', firstname: 'jessica', lastname: 'jones', admin: 'true'
end

def create_user
	@user = User.create! email: 'ironman@stark.industries.com', password: 'jarvis', 
	firstname: 'tony', lastname: 'stark'
end

def create_multiple_users
	@one = User.create email:'luke_cage@superhero.com', password: 'harlem_heat', firstname: 'luke', lastname: 'cage', admin: 'false'
	@two = User.create email:'murdoch@superhero.com', password: 'daredevil', firstname: 'matt', lastname: 'murdoch', admin: 'false'
	@three = User.create email:'punisher@antihero.com', password: 'punishThem', firstname: 'frank', lastname: 'castle', admin: 'false'
	@four = User.create email:'nelsonandmurdoch@lawyers.com', password: 'sidekick', firstname: 'foggy', lastname: 'nelson', admin: 'true'
	@five = User.create email:'badguyincorporated@acme.com', password: 'master0criminal', firstname: 'wilson', lastname: 'fisk', admin: 'false'
end

def log_in(email, password)
	visit root_path
	click_link('Log In')
	fill_in 'Email', with: email
	fill_in('Password', with: password, match: :prefer_exact)
  	click_button 'Log in'
end


RSpec.feature 'Testing functionality of the User features' do

	scenario '- User signs in' do
		create_user
		log_in(@user.email, @user.password)
		expect(page).to have_content('Signed in successfully.')
	end

	scenario '- User attempts to sign in with incorrect details' do
		create_user
		log_in(@user.email, 'incorrectPassword')
		expect(page).to have_content('Invalid')
	end

	scenario '- User signs out' do
		create_user
		log_in(@user.email, @user.password)
		click_link('Sign Out')
		expect(page).to have_content('Signed out successfully')
	end

	scenario '- User views their details' do
		create_user
		log_in(@user.email, @user.password)
		expect(page).to have_content('successfully')
		page.click_link('', :href => '/user/show')
		expect(page).to have_content('My Account Details')
		expect(page).to have_content('Standard')
	end

	scenario '- User edits their password' do
		create_user
		log_in(@user.email, @user.password)
		page.click_link('', :href => '/user/show')
		click_link('Edit')
		fill_in('Password', :with => 'newPassword', :match => :prefer_exact)
		fill_in('Password confirmation', :with => 'newPassword', :match => :prefer_exact)
		fill_in('Current password', :with => @user.password, :match => :prefer_exact)
		click_button('Update')
		expect(page).to have_content('Your account has been updated successfully')
	end

	scenario '- Admin user edits their lastname' do
		create_admin
		log_in(@admin.email, @admin.password)
		page.click_link('', href: '/user/show')
		click_link('Edit')
		fill_in 'Lastname', with: 'dynamite-jones'
		fill_in('Current password', with: @admin.password, match: :prefer_exact)
		click_button('Update')
		expect(page).to have_content('Your account has been updated successfully')
	end

	scenario ' - Admin user views all users details' do
		create_admin
		log_in(@admin.email, @admin.password)
		page.click_link('', :href => '/admin_simple/index')
		click_link('Edit users')
		expect(current_path).to eq '/user'
 	end

	scenario '- Admin amends a user account to Admin status' do
		create_multiple_users
		create_admin
		log_in(@admin.email, @admin.password)
		page.click_link('', :href => '/admin_simple/index')
		click_link('Edit users')
		click_link('Edit', match: :first)
		check('Admin')
		click_button('Update User')
		expect(page).to have_content('luke_cage@superhero.com has been successfully been updated')
	end

	scenario '- Admin user deletes a single user' do
		create_multiple_users
		create_admin
		log_in(@admin.email, @admin.password)
		page.click_link('', :href => '/admin_simple/index')
		click_link('Edit users')
		click_link('Edit', match: :first)
		click_link('Delete User', match: :first)
		expect(page).to have_content("#{@one.email} has successfully been deleted!" )
	end

	scenario 'Admin user attempts to delete themselves' do
		create_admin
		log_in(@admin.email, @admin.password)
		page.click_link('', :href => '/admin_simple/index')
		click_link('Edit users')
		click_link('Edit', match: :first)
		click_link('Delete User', match: :first)
		expect(page).to have_content("You can not delete yourself, please instruct another admin user to do so on your behalf!")
	end

	#incomplete
	scenario '- Admin invites a potential user' do
		create_admin
		log_in(@admin.email, @admin.password)
		page.click_link('', :href => '/admin_simple/index')
		click_link('Invite a user')
	end
	
end
