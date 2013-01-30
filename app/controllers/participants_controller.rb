class ParticipantsController < ApplicationController
  before_filter :authenticate_user!, except: [:new, :create]
  
  def new
    @participant=Participant.new
  end
  
  def create
    @participant = Participant.new(params[:participant])
    #Randomly assign a reminder strategy
    @participant.reminder_strategy = [IntervalConsistentStrategy,IntervalSampleStrategy].sample.name.underscore
    #if verify_recaptcha
      #flash.discard(:recaptcha_error)
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
    #else
      #@participant.valid?
      #flash[:recaptcha_error] = "Try again:\n Your captcha response didn't match. Are you a robot?"
      #render 'new'
    #end
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
  
  def mass_message
    medium = Message::TEXT
    content = params[:content]
    status = params[:participant_status]
    timing = params[:timing]
    if status and timing and content and content.length > 0 and params[:submit] == "schedule_message"
      Participant.find_all_by_status(status).each do |p|
        Time.zone = "Pacific Time (US & Canada)"        
        case timing
        when "with_next_pending_message" 
          time = p.messages.find_all_by_status(Message::PENDING).map {|m| m.scheduled_at}.min
        when "next_noon_local"
          tString = (DateTime.tomorrow-24*60*60).to_s + " 12:00 " + p.time_zone_long
          time = DateTime.strptime(tString, '%Y-%m-%d %k:%M %Z')   
          while time < DateTime.now
            time += 24*60*60
          end
        when "tomorrow_noon_local"
          tString = DateTime.tomorrow.to_s + " 12:00 " + p.time_zone_long
          time = DateTime.strptime(tString, '%Y-%m-%d %k:%M %Z')              
        when "in_15_minutes"
          time = DateTime.now + 15.0/(24*60)
        end
        puts time
        if time
          message = p.messages.build(medium:medium,status:Message::PENDING,content:content, scheduled_at:time)
          message.save
        end
      end
      redirect_to active_participants_path
    end                            
  end

  def setNextReminders    
    Participant.find_all_by_status(Participant::ACTIVE).each {|p| p.setNextReminderMessage}
    redirect_to request.referer    
  end
          
  def active
    @count_pendingMessages=ProjectMessage.find_all_by_status(Message::PENDING).count
    @participants = Participant.paginate  :page => params[:page], :per_page => 5, 
                                          :conditions => ['status = ?', Participant::ACTIVE]
    if params[:message_window_in_days]
      @message_window_in_days = params[:message_window_in_days].to_f
    else
      @message_window_in_days = 1.25
    end
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
