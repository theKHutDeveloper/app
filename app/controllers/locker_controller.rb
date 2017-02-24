class LockerController < ApplicationController
	before_action :authenticate_user!
	before_action :edit_params, :only =>[ :update]

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

			if Locker.exists?(ref: @locker.ref)
				flash[:danger] = "Error - You attempted to create a locker that already exists"
				render 'new'
			else
				if @locker.save
					flash[:success] = "You successfully created a new locker"
					redirect_to admin_simple_index_path
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
			@assigned_users = User.where(locker_id: @locker.id)
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
		@locker = Locker.find(params[:id])    		
		@user = User.find(params[:locker][:users])
		@assigned_users = User.where(locker_id: @locker.id)

		if @assigned_users.count > 0
			@locker.shared = true
		else
			@locker.shared = false
		end

		@user.locker_id = @locker.id
		@locker.status = "Assigned"
		@locker.save
		@user.save

		flash[:success] = "#{@user.email} has been successfully assigned to locker #{@locker.ref}"
	
		redirect_to locker_path(@locker.id)
	end 

	def remove_user
		@removed_user = User.find(params[:format])
		@locker = Locker.find(@removed_user.locker_id)
		@assigned = (@locker.users.count) - 1
		@removed_user.locker_id = nil

		if @assigned < 2  
			@locker.shared = false
		else 
			@locker.shared = true
		end

		if @assigned < 1
			@locker.status = "Free"
		else
			@locker.status = "Assigned"
		end
		
		@locker.save
		@removed_user.save
		
		flash[:success] = "#{@removed_user.email} has been removed from locker #{@locker.ref}"
		redirect_to locker_path(@locker.id)
	end

	def show
		
		@locker = Locker.find(params[:id])
		@assigned_users = @locker.users
		@users = User.where(locker_id: nil)
    

		

		# #valid user found
		# else
		# 	#admin chose to add user to locker
		# 	if @user.present?
		# 		@locker.status = "Assigned"

		# 		#not shared if no other users assigned the locker
		# 		if @locker_users.nil?
		# 			@locker.shared = false
		# 		elsif @locker_users > 0
		# 			@locker.shared = true
		# 		end

		# 		#add locker id to user, save locker and user record
		# 		@user.locker_id = @locker.id
		# 		@locker.save!
		# 		@user.save!	

		# 		flash[:success] = "#{@user.email} has been assigned to locker #{@locker.ref}"

		# 	#admin chose to delete user from locker
		# 	else
		# 		#get correct locker status and shared value
		# 		if @locker_users < 2  
		# 			@locker.shared = false
		# 			@locker.status = "Free"
		# 		elsif @locker_users < 3
		# 			@locker.shared = false
		# 			@locker.status = "Assigned"
		# 		elsif @locker_users > 2
		# 			@locker.shared = true
		# 			@locker.status = "Assigned"
		# 		end

		# 		#delete user's locker id, save locker and user
		# 		@selected_user.locker_id = nil
		# 		@locker.save
		# 		@selected_user.save

		# 		flash[:success] = "#{@selected_user.email} has been removed from locker #{@locker.ref}"
		# 	end
		
	end

	private

		def locker_params
			params.require(:locker).permit(
				:ref, :floor, :location, :size, :status, :shared
				)
		end

		def edit_params
			#params.require(:locker).permit(:users)
			params.permit(locker: [ users: [:id]])
			#params.permit(users: [:id])
			#params.require(:locker).permit(:users).permit(:id)
			#params.permit(:utf8, :authenticity_token, :locker[:user[:id]], :id)
			
			#params.permit[:locker, { users: :id } ]
			# params.permit
			# params.permit(:locker)
			# params.permit(:users)
			#params.require(:user).permit(:email, :locker_id)
			#params.require(:locker).permit(user: [:locker_id])
		end
end