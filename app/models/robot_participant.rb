
class RobotParticipant < Participant
  def messageDelivered(message)
    self.receiveMessage("ROBOT PARTICIPANT REPLY.",message.medium)
  end
end
