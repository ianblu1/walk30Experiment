class StaticPagesController < ApplicationController
  def home
  end
  
  def contact
  end
  
  def instructions
  end
  
  def welcome
  end
  
  def twilio_receive
    phone = params[:From][2..11]
    content = params[:Body]
    account_sid = params[:AccountSid]
    participant = Participant.withPhone(phone)
    @sms = nil #This is the body of the automated reply message. If nil, no reply message will be sent.
    if participant and account_sid == Message::TWILIO_ACCOUNT_SID
      if participant.messages
        lastMessage = participant.messages.last
        if lastMessage.received? and lastMessage.content==content and (DateTime.now - lastMessage.created_at) < 30
          logger.info "Duplicate message received but not recorded."
          return
        else
          participant.receiveMessage(content,Message::TEXT)
          #@sms = participant.email
        end
      end
    end
  end
  
end
