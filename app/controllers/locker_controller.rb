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
		@locker = Locker.find(params[:id])
		@users = User.where(locker_id: @locker.locker_id)
		@assigned = true

		if @users.count == 0
			@users = User.where(locker_id: nil) 
			@assigned = false
		end
	end


	def update
		@locker = Locker.find(params[:id])

		#count the number of users who are assigned to this locker id
		@locker_users = User.where(locker_id: @locker.locker_id).count

		#retrieves email chosen in edit.html.erb from collection_select
		params[:locker].each do |k, v|
      		@user = v
    	end

    	#get user record that matches with email
    	@selected_user = User.where(email: @user).first

    	#if no matching user record exit out of save/update
    	if @selected_user.nil?
    		flash[:danger] = "Unidentified User - No changes have been made!"
			redirect_to 'edit'
		else
			#valid user found
			@locker.status = "Assigned"

			#not shared if no other users assigned the locker
			if @locker_users.nil?
				@locker.shared = false
			elsif @locker_users > 0
				@locker.shared = true
			end

			@selected_user.locker_id = @locker.locker_id
			@locker.save
			@selected_user.save	
			
			flash[:success] = "#{@selected_user.email} has been assigned to locker #{@selected_user.locker_id}"
		
			render 'show'
		end

	end 

	def test
		@locker = Locker.find(params[:format])
	
		@assigned_user = User.where(locker_id: @locker.locker_id)

		$count = @assigned_user.count

		$i = 0

		while $i < $count  do
   			#puts("Inside the loop i = #$i" )
   			#add email of user
   			$i += 1
		end
		
		flash[:danger] = "locker is #{@locker.locker_id} with #{$count} users"
	end


	def show
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
