class MessagesController < ApplicationController

  def deliver
    Message.find(params[:id]).deliver
    redirect_to request.referer
  end
  
  def flagPositive
    Message.find(params[:id]).flagPositive
    redirect_to request.referer
  end

  def flagNegative
    Message.find(params[:id]).flagNegative
    redirect_to request.referer
  end

  def flagNeutral
    Message.find(params[:id]).flagNeutral
    redirect_to request.referer
  end
  
  def summary
    @participants = Participant.paginate(page: params[:page])
  end  


end
