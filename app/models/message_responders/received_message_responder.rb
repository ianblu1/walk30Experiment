class ReceivedMessageResponder
  
  def self.respondToMessage(message)
    false
  end
  
  def self.replyToMessageWithContent(message,content)
    message.participant.messages.build(content:content,medium:message.medium,status:Message::PENDING,scheduled_at:DateTime.now)
  end
  
end