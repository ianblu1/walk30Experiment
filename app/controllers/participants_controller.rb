class ParticipantsController < ApplicationController
  before_filter :authenticate_user!, only: [:index, :show, :summary]
  
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
      
  def index
    @participants = Participant.paginate(page: params[:page])
  end
  
  def show
    @participant = Participant.find(params[:id])
    @messages = @participant.messages(page: params[:page])
  end
  
  def summary
    @participants = Participant.paginate(page: params[:page])
  end  
  
end
