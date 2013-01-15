class ParticipantsController < ApplicationController
  before_filter :authenticate_user!, except: [:new, :create]
  
  def new
    @participant=Participant.new
  end
  
  def create
    @participant = Participant.new(params[:participant])
    if verify_recaptcha
      if @participant.save
        if @participant.activate
          flash[:success] = "Welcome to Walk30!"
          redirect_to instructions_path
        else
          Participant.delete(@participant.id)
          flash[:error] = "Try again:\n We can't send text messages to the phone number you provided."
          redirect_to signup_path
        end
      else
        render 'new'
      end
    else
      flash[:error] = "Try again:\n Your captcha response didn't match. Are you a robot?"
      render 'new'
    end
  end  
  
  def update
    render 'new'
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

  def setNextDay    
    Participant.setUpNextDaysTextMessages()
    redirect_to request.referer    
  end
  
  def autoflag
    Participant.autoflagParticipantMessages
    redirect_to request.referer
  end
  
  def terminate
      Participant.find(params[:id]).terminate
      redirect_to request.referer
  end
      
  def index
    @count_pendingMessages=ProjectMessage.find_all_by_status(0).count
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
  
end
