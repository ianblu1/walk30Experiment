class DailyReminderMessage < Message
  
  def autoflag
    puts self.id
    replies = self.replies
    if replies and replies.length > 0 
      if replies.map{|r| r.flag}.uniq.length == 1
        self.flag = replies[0].flag
        self.save
      end  
    else
      self.flagNeutral
    end
  end

end
