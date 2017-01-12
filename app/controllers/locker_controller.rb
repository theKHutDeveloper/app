class LockerController < ApplicationController
	before_action :authenticate_user!

	def index
		if current_user.admin? && params[:status].blank?
			@locker = Locker.complete
		elsif current_user && params[:status] == 'Free'
			@locker = Locker.available
		end
	end

	def new
		if current_user.admin?
			@locker = Locker.new
		else
			redirect_to root_path
		end
	end


	def create
		if current_user.admin?
			@locker = Locker.new(locker_params)

			if Locker.exists?(locker_id: @locker.locker_id)
				flash[:danger] = "Error - You attempted to create a locker that already exists"
				render 'new'
			else

				if @locker.save
					flash[:success] = "You successfully created a new locker"
					render 'show'
				else
					render 'new'
				end
			end

		end
	end


	def show
		@locker = Locker.find(params[:id])
	end

	private

		def locker_params
			params.require(:locker).permit(:locker_id, :floor, :location, :size, :status, :shared)
		end

	
end
