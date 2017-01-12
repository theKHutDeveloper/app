class UserController < ApplicationController
    before_action :authenticate_user!

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

  def index
  end

  def show
    if current_user
      @lockers = Locker.joins(:users)
    end
  end
  
end
