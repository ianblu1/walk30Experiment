class DailyReminderMessage < Message
  
  def autoflag
    replies = self.replies
    if replies and replies.length > 0 & replies.unique.length == 1
      self.flag = replies[0]
      self.save
    end
  end

end
