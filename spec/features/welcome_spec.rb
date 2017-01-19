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



RSpec.feature 'Not registered user accessing the Welcome Page Features' do

	scenario 'Non registered user clicks on Avaiable Lockers' do
		visit root_path
		page.click_link('', :href => '/locker?status=Free')
		expect(page).to have_content('You need to sign in or sign up before continuing')
	end

 	scenario 'Non registered user clicks on View Your Messages' do
	 	visit root_path
		page.click_link('', :href => '/message/index')
		expect(page).to have_content('You need to sign in or sign up before continuing')
 	end

	scenario 'Non registered user clicks on View Account Details' do
		visit root_path
		page.click_link('', :href => '/user/show')
		expect(page).to have_content('You need to sign in or sign up before continuing')
	end

	scenario 'Non registered user clicks on Administrators' do
		visit root_path
		page.click_link('', :href => '/admin_simple/index')
		expect(page).to have_content('You need to sign in or sign up before continuing')
	end

end


RSpec.feature 'Logged in users accessing the Welcome Page Features' do

	scenario 'Basic user clicks on Avaiable Lockers' do
		visit root_path
		createUser
		logIn(@non_admin.email, @non_admin.password)
		page.click_link('', :href => '/locker?status=Free')
		expect(page).to have_content('Available Lockers')
	end

	scenario 'Basic user clicks on View Your Messages' do
		visit root_path
		createUser
		logIn(@non_admin.email, @non_admin.password)
		page.click_link('', :href => '/message/index')
		expect(page).to have_content('Message Inbox')
	end

	scenario 'Basic user clicks on View Account Details' do
		visit root_path
		createUser
		logIn(@non_admin.email, @non_admin.password)
		page.click_link('', :href => '/user/show')
		expect(page).to have_content('My Account Details')
	end

	scenario 'Basic user clicks on Administrators' do
		visit root_path
		createUser
		logIn(@non_admin.email, @non_admin.password)
		page.click_link('', :href => '/admin_simple/index')
		expect(page).to have_content('You do not have access to this section')
	end

	scenario 'Admin user clicks on Avaiable Lockers' do
		visit root_path
		createAdmin
		logIn(@user.email, @user.password)
		page.click_link('', :href => '/locker?status=Free')
		expect(page).to have_content('Available Lockers')
	end

	scenario 'Admin user clicks on View Your Messages' do
		visit root_path
		createAdmin
		logIn(@user.email, @user.password)
		page.click_link('', :href => '/message/index')
		expect(page).to have_content('Message Inbox')
	end

	scenario 'Admin user clicks on View Account Details' do
		visit root_path
		createAdmin
		logIn(@user.email, @user.password)
		page.click_link('', :href => '/user/show')
		expect(page).to have_content('My Account Details')
	end

	scenario 'Admin user clicks on Administrators' do
		visit root_path
		createAdmin
		logIn(@user.email, @user.password)
		page.click_link('', :href => '/admin_simple/index')
		expect(page).to have_content('Administration Panel')
	end
end

