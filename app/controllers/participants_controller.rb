class ParticipantsController < ApplicationController
  before_filter :authenticate_user!, only: [:index, :show]
  
  def new
    @participant=Participant.new
  end
  
  def create
    @participant = Participant.new(params[:participant])
    if @participant.save
      flash[:success] = "Welcome to Walk30!"
      redirect_to root_path
    else
      render 'new'
    end
  end  
  
  def index
    @participants = Participant.paginate(page: params[:page])
  end
  
  def show
    @participant = Participant.find(params[:id])
  end  
  
end
