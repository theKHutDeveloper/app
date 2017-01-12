class AdminSimpleController < ApplicationController
	before_action :authenticate_user!
	before_action :admin_user, :only =>[ :index ]

  def index
  end


  private
  	
  	def admin_user
  		if current_user.admin
			return
	  	else
	  		flash[:danger] = 'You do not have access to this section'
	  		redirect_to root_path
	  	end
    end

end
