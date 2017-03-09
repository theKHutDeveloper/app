class UserController < ApplicationController
    before_action :authenticate_user!
    before_action :admin_user, :only =>[ :index, :edit]
    before_action :edit_status, :only =>[:update]

    def index
      @users = User.all.paginate(:page => params[:page], :per_page => 10)
      @lockers = Locker.joins(:users)
      
      if !current_user.locker_id.nil?
        @locker = Locker.all
      end 
    end

    def new
    end

    def create
    end

    

    def edit
      if current_user.admin?
        @user = User.find(params[:id])
      else
        flash[:danger] = "You do not have permission to access this page"
        redirect_to root_path
      end
     
    end


    def update
      puts params
      @user = User.find(params[:id])
 
      if @user.update_attributes(edit_status)
        flash[:success] = "#{@user.email} has been successfully been updated"
        redirect_to user_index_path
      else
        render 'edit'
      end
    end


    def destroy
      @user = User.find(params[:id])

      if current_user.email != @user.email 
        User.find(params[:id]).destroy
        flash[:success] = "User #{@user.email} has successfully been deleted!"
      else
        flash[:danger] = "You can not delete yourself, please instruct another admin user to do so on your behalf!"
      end

      redirect_to user_index_path
    end


    def show
      if current_user
        @lockers = Locker.joins(:users)

        if !current_user.locker_id.nil?
            @locker = Locker.find(current_user.locker_id)
        end
      end
    end


    private 

      def admin_user
        if current_user.admin
          return
        else
          flash[:danger] = 'You do not have valid credentials to view the Administration Panel'
          redirect_to root_path
        end
      end


      def edit_status
        params.require(:user).permit(:admin)

      end 
  
end
