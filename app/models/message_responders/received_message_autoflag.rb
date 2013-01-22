class ReceivedMessageAutoflag < ReceivedMessageResponder
  
  def self.respondToMessage(message)
    c = message.content.downcase.strip
    if c.length < 7
      if /yes/.match(c) or /walk/.match(c) 
        message.flagPositive
      elsif /no/.match(c)
        message.flagNegative
      end
    end
  end
  
end