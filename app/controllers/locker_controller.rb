class LockerController < ApplicationController
	before_action :authenticate_user!

	def index
		if current_user.admin? && params[:status].blank?
			@locker = Locker.complete
		elsif current_user && params[:status] == 'Free'
			@locker = Locker.available
		else
			flash[:danger] = "You do not have permission to access this page"
			redirect_to root_path
		end
	end


	def new
		if current_user.admin?
			@locker = Locker.new
		else
			flash[:danger] = "You do not have permission to create a new locker"
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


	def edit
		if current_user.admin?
			@locker = Locker.find(params[:id])
			@users = User.where(locker_id: nil)
			@assigned_users = User.where(locker_id: @locker.locker_id)
			@assigned = false

			if @assigned_users.count > 0
				@assigned = true
			end
		else
			flash[:danger] = "You do not have permission to access this page"
			redirect_to root_path
		end
	end


	def update
		#return the specified locker
		@locker = Locker.find(params[:id])

		#count the number of users who are assigned to this locker id
		@locker_users = User.where(locker_id: @locker.locker_id).count

		if params[:user] #admin has selected user to delete
			@selected_user = User.find(params[:user])
		else #admin has selected user to add
			params[:locker].each do |k, v|
      			@found = v
    		end
    		#get the first(and only)user with specified email
    		@user = User.where(email: @found).first
		end

    	#invalid user - no user selected for delete or addition
    	if @selected_user.nil? && @user.nil?
    			@locker.update(floor: @locker.floor)
    			render 'show'
    		
		#valid user found
		else
			#admin chose to add user to locker
			if @user.present?
				@locker.status = "Assigned"

				#not shared if no other users assigned the locker
				if @locker_users.nil?
					@locker.shared = false
				elsif @locker_users > 0
					@locker.shared = true
				end

				#add locker id to user, save locker and user record
				@user.locker_id = @locker.locker_id
				@locker.save!
				@user.save!	

				flash[:success] = "#{@user.email} has been assigned to locker #{@locker.locker_id}"

			#admin chose to delete user from locker
			else
				#get correct locker status and shared value
				if @locker_users < 2  
					@locker.shared = false
					@locker.status = "Free"
				elsif @locker_users < 3
					@locker.shared = false
					@locker.status = "Assigned"
				elsif @locker_users > 2
					@locker.shared = true
					@locker.status = "Assigned"
				end

				#delete user's locker id, save locker and user
				@selected_user.locker_id = nil
				@locker.save
				@selected_user.save

				flash[:success] = "#{@selected_user.email} has been removed from locker #{@locker.locker_id}"
			end
			
			render 'show'
		end
	end 


	def show
		#show needs to show users details if applicable
		@selected_user = User.find(params[:user])
		@locker = Locker.find(params[:id])
	end

	private

		def locker_params
			params.require(:locker).permit(:locker_id, :floor, :location, :size, :status, :shared)
		end

		def edit_params
			params.require(:user).permit(:email, :locker_id)
		end
end