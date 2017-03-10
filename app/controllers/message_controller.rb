class MessageController < ApplicationController
	before_action :authenticate_user!

  def index
    #@messages = current_user.received_messages
  end

  def outbox
    #@messages = current_user.sent_messages
  end

  def show
    #@message = current_user.messages.find(params[:id])
  end

  def destroy
    #@message = current_user.messages.find(params[:id])
    #if @message.destroy
     # flash[:notice] = "Message Deleted"
    #else
     # flash[:error] = "Something went wrong"
    #end
  end

  def new
    @message = Message.new
    @message.user_id = current_user.id
    @recipient = User.where.not(id: current_user.id)

  end

  def create
    #if @message.valid?
    #@to = User.find_by_email(params[:message][:to])
    #Message.send_message(@to, params[:message][:topic], params[:message][:body])
    #end
  end
end
