class ParticipantsController < ApplicationController
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
  
end
