class ParticipantsController < ApplicationController
  before_filter :authenticate_user!, except: [:new, :create]
  
  def new
    @participant=Participant.new
  end
  
  def create
    @participant = Participant.new(params[:participant])
    if verify_recaptcha
      if @participant.save
        flash[:success] = "Welcome to Walk30!"
        redirect_to instructions_path
      else
        render 'new'
      end
    else
      flash[:error] = "Something wrong with the captcha info."
      render 'new'
    end
  end  
  
  def activate
      Participant.find(params[:id]).activate
      redirect_to request.referer
  end

  def reactivate
      Participant.find(params[:id]).reactivate
      redirect_to request.referer
  end

  def deliverMessage
    if params[:delay_in_hours] == ''
      Participant.find(params[:id]).deliverMessage(params[:content],params[:medium])
    else
      time = DateTime.now() + params[:delay_in_hours].to_f/24
      Participant.find(params[:id]).pendingMessageWithTime(params[:content],params[:medium],time)
    end
    redirect_to request.referer
  end

  def terminate
      Participant.find(params[:id]).terminate
      redirect_to request.referer
  end
      
  def index
    @participants = Participant.paginate  :page => params[:page], :per_page => 5, 
                                          :conditions => ['status = ?', Participant::ACTIVE]
    @Participant = Participant
  end
  
  def show
    @participant = Participant.find(params[:id])
    @message = @participant.messages.build
    @messages = @participant.messages(page: params[:page]).sort_by {|message| message.id}
  end
  
  def summary
    @participants = Participant.paginate(page: params[:page])
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
