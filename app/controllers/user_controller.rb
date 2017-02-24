class UserController < ApplicationController
    before_action :authenticate_user!
    before_action :admin_user, :only =>[ :index]

    def index
      @users = User.all
      @lockers = Locker.joins(:users)
      
    end

    def new
    end

    def create
    end

    def update
    end

    def edit
    end

    def destroy
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

  
end
