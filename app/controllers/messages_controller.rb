class MessagesController < ApplicationController
  before_action :require_user
  
  def create
    @message = Message.new(message_params)
    @message.chef = current_chef
    if @message.save
      ActionCable.server.broadcast 'chatroom_channel', message: render_message(@message),
                                                        chef: @message.chef.chefname

    else
      flash[:danger] = "Non è stata possibile ad inserire il commento"
      redirect_to :back    
    end
  end
  
  private
  
  def message_params
    params.require(:message).permit(:content)
  end
  
  def render_message(message)
    render(partial: 'message', locals: { message: message } )
  end
end