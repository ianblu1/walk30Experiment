class MessagesController < ApplicationController
  before_filter :authenticate_user!
  
  def deliver
    Message.find(params[:id]).deliver
    redirect_to request.referer
  end
  
  def cancel
    Message.find(params[:id]).cancel
    redirect_to request.referer
  end  
  
  def update
    m = Message.find(params[:id])
    if params[:flagPositive]
      m.flagPositive
    end
    if params[:flagNegative]
      m.flagNegative
    end
    if params[:flagNeutral]
      m.flagNeutral
    end
    redirect_to request.referer
  end  
  
  def destroy
    Message.find(params[:id]).delete
    redirect_to request.referer
  end


end
