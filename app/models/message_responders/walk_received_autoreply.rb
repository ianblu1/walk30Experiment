class WalkReceivedAutoreply < ReceivedMessageResponder
  
  def self.respondToMessage(message)
    c = message.content.downcase.strip
    if /walk/.match(c) and c.length < 8
      m = self.replyToMessageWithContent(message,"Walk30:\nGlad to hear! Thanks for letting us know.")
      m.save
      m.deliver
    end
  end
  
end
