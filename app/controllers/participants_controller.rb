class ParticipantsController < ApplicationController
  before_filter :authenticate_user!, except: [:new, :create]
  
  def new
    @participant=Participant.new
  end
  
  def create
    @participant = Participant.new(params[:participant])
    if verify_recaptcha
      flash.discard(:recaptcha_error)
      if @participant.save
        if @participant.activate
          redirect_to welcome_path
        else
          Participant.delete(@participant.id)
          flash[:error] = "Try again:\n We can't send text messages to the phone number you provided."
          redirect_to signup_path
        end
      else
        render 'new'
      end
    else
      @participant.valid?
      flash[:recaptcha_error] = "Try again:\n Your captcha response didn't match. Are you a robot?"
      render 'new'
    end
  end  
  
  def update
    puts params
    p = Participant.find(params[:id])
    if params[:activate]
      p.activate
    end
    if params[:reactivate]
      p.reactivate
    end
    if params[:terminate]
      p.terminate
    end
    p.save
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

  def setNextReminders    
    Participant.find_all_by_status(Participant::ACTIVE).each {|p| p.setNextReminderMessage}
    redirect_to request.referer    
  end
          
  def active
    @count_pendingMessages=ProjectMessage.find_all_by_status(Message::PENDING).count
    @participants = Participant.paginate  :page => params[:page], :per_page => 5, 
                                          :conditions => ['status = ?', Participant::ACTIVE]
    @messages_filter =
    @Participant = Participant
  end
  
  def show
    @participant = Participant.find(params[:id])
    @message = @participant.messages.build
    @messages = @participant.messages(page: params[:page]).sort_by {|message| message.id}
  end
  
  def index
    @participants = Participant.paginate(page: params[:page])
  end  
  
  def destroy
    Participant.find(params[:id]).delete
    redirect_to request.referer
  end
    
end
