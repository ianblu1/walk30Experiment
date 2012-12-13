class AddSurveyQuestionsToParticipants < ActiveRecord::Migration
  def change
    add_column :participants, :morning_reminder, :boolean
    add_column :participants, :walked_last_week, :integer, default: 0
  end
end
