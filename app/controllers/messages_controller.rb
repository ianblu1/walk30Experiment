class MessagesController < ApplicationController

  def new
    @message=Participant.new
  end
  
  def create
    @message = Message.new(params[:message])
  end  
  
  def show
    @participant = Participant.find(params[:id])
    @messages = @participant.messages(page: params[:page])
  end

  def deliver
      Message.find(params[:id]).deliver
      redirect_to request.referer
  end      
  
  def summary
    @participants = Participant.paginate(page: params[:page])
  end  


end
