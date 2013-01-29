class AddReminderStrategyToParticipants < ActiveRecord::Migration
  def change
    add_column :participants, :reminder_strategy, :string, :default => "ian_reminder_strategy"
  end
end
