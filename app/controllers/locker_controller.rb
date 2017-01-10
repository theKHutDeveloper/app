class LockerController < ApplicationController
	#before_action :authenticate_user!

	def index
		if current_user.admin? && params[:status].blank?
			@lockers = Locker.complete
		elsif current_user && params[:status] == 'Free'
			@lockers = Locker.available
		end
	end
end
