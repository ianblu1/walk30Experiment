class DailyReminderMessage < Message
  
  def autoflag
    replies = self.replies
    if replies and replies.length > 0 and replies.map{|r| r.flag}.uniq.length == 1
      self.flag = replies[0].flag
      self.save
    end
    return replies  
  end

end
