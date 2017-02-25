class LockerController < ApplicationController
	before_action :authenticate_user!
	before_action :edit_params, :only =>[ :update]
	before_action :locker_params, :only =>[ :update, :create]

	def index
		if current_user.admin? && params[:status].blank?
			@locker = Locker.complete.paginate(:page => params[:page], :per_page => 10)
		elsif current_user && params[:status] == 'Free'
			@locker = Locker.available.paginate(:page => params[:page], :per_page => 10)
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

		else
			flash[:danger] = "You do not have permission to access this page"
			redirect_to root_path
		end
	end


	def update
		@locker = Locker.find(params[:id])  

		if params[:locker][:users].present?		
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
		else
			#if params[:floor][:location][size].present?
			if @locker.update_attributes(edit_params)
				flash[:success] = "You successfully updated locker #{@locker.ref}"
			else
				render 'edit'
			end
		end
		
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
	end

	def destroy
		Locker.find(params[:id]).destroy
		flash[:success] = "Locker has been deleted"
		redirect_to locker_index_path
	end

private

	def locker_params
		params.require(:locker).permit(:ref, :floor, :location, :size, :status, :shared)
	end

	def edit_params
		params.require(:locker).permit(:ref, :floor, :location, :size)
	end	
end
