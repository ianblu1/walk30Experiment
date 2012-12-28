class StaticPagesController < ApplicationController
  def home
  end
  
  def contact
  end
  
  def instructions
  end
  
  def twilio_receive
    phone = params[:From][2..11]
    content = params[:Body]
    participant = Participant.participantWithPhone(phone)
    if participant
      participant.receiveMessage(content,Message::TEXT)
    end
  end
  
end
