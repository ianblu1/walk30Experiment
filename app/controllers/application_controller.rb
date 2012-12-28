class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_path
  end 
  
  def after_sign_in_path_for(resource)
      participants_path
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
