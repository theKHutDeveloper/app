require File.dirname(__FILE__) + '/../rails_helper'
require File.dirname(__FILE__) + '/../../test/test_helper.rb'

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

RSpec.feature 'Logged in user interacts with the messaging feature' do

	scenario 'User visits the Message Index page' do
		create_multiple_users
		log_in(@two.email, @two.password)
		visit root_path
		page.click_link('', :href => '/message')
		expect(page).to have_content('Message Inbox')
	end

	scenario 'User sends a message to Luke Cage' do
		create_multiple_users
		log_in(@two.email, @two.password)
		visit root_path
		page.click_link('', :href => '/message')
		click_link('Compose')
		select @one.email, :from => @recipient
		fill_in 'Topic', with: 'Test'
		fill_in 'Body', with: 'This is just a test'
		click_button('Create Message')
		expect(page).to have_content('Your message has been sent')
	end

end